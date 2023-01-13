#!/bin/sh

timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
source_dir='/source'
target_dir='/target/remote-backup'
backup_name="remote-backup-$(date +'%Y-%m-%d_%H.%M.%S')"
backup_retention_days="7"

# set environment variables defined by docker
if [ -n "${REMOTE_BACKUP_RETENTION_DAYS}" ]; then
  backup_retention_days=${REMOTE_BACKUP_RETENTION_DAYS}
fi

echo "[${timestamp}] Starting remote backup" >> /proc/1/fd/1

# create directories if not existing
mkdir -p ${source_dir} ${target_dir}

# retention policy: delete previous backups
echo "[${timestamp}] Removing previous backups respecting the retention policy > ${backup_retention_days} day(s)" >> /proc/1/fd/1
rclone delete --skip-trash --min-age "${backup_retention_days}d" remote:${target_dir}
find ${target_dir} -type f -mtime +${backup_retention_days} -delete

# stop containers labeled with "dockup-backup-stop=true"
echo "[${timestamp}] Stopping containers labeled with 'dockup-backup-stop=true'" >> /proc/1/fd/1
docker stop $(docker ps -q --filter label=dockup-backup-stop=true)

# create the backup
echo "[${timestamp}] Creating backup" >> /proc/1/fd/1
if [ -n "${REMOTE_BACKUP_PASSPHRASE}" ]; then
  echo "[${timestamp}] Encrypting using given passphrase" >> /proc/1/fd/1
  tar -czf - ${source_dir} | gpg -c --cipher-algo AES256 --passphrase "${REMOTE_BACKUP_PASSPHRASE}" --batch -o "${target_dir}/${backup_name}.tar.gz.gpg" >> /proc/1/fd/1
else
  echo "[${timestamp}] Passphrase is empty, skip encryption" >> /proc/1/fd/1
  tar -czf "${target_dir}/${backup_name}.tar.gz" ${source_dir} >> /proc/1/fd/1
fi

# check if the backup creation was successful
if [ $? -ne 0 ]; then
  echo "[${timestamp}] Error: Backup creation failed" >> /proc/1/fd/1
  exit 1
fi

# restart stopped containers
echo "[${timestamp}] Restaring stopped containers" >> /proc/1/fd/1
docker restart $(docker ps -q --filter label=dockup-backup-stop=true --filter "status=exited")

# copy the backup
echo "[${timestamp}] Copying backup" >> /proc/1/fd/1
if [ -n "${REMOTE_BACKUP_PASSPHRASE}" ]; then
  rclone copy "${target_dir}/${backup_name}.tar.gz.gpg" remote:${target_dir} --progress --verbose --stats 15m >> /proc/1/fd/1
else
  rclone copy "${target_dir}/${backup_name}.tar.gz" remote:${target_dir} --progress --verbose --stats 15m >> /proc/1/fd/1
fi

# check if the backup copying was successful
if [ $? -ne 0 ]; then
  echo "[${timestamp}] Error: Backup copying failed" >> /proc/1/fd/1
  exit 1
fi

echo "[${timestamp}] Backup completed successfully" >> /proc/1/fd/1