#!/bin/sh

timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
source_dir='/source'
target_dir='/target/full-backup'
backup_name="full-backup-$(date +'%Y-%m-%d_%H.%M.%S')"
backup_retention="7"

# set environment variables defined by docker
if [ -n "${FULL_BACKUP_RETENTION}" ]; then
  backup_retention=${FULL_BACKUP_RETENTION}
fi

echo "[${timestamp}] Starting full backup" >> /proc/1/fd/1

# create directories if not existing
mkdir -p ${source_dir} ${target_dir}

# retention policy: delete previous backups
echo "[${timestamp}] Removing previous backups respecting the retention policy > ${backup_retention} day(s)" >> /proc/1/fd/1
find ${target_dir} -type f -mtime +$backup_retention -delete

# stop containers labeled with "dockup-backup-stop=true"
echo "[${timestamp}] Stopping containers labeled with 'dockup-backup-stop=true'" >> /proc/1/fd/1
docker stop $(docker ps -q --filter label=dockup-backup-stop=true)

# create the backup
echo "[${timestamp}] Creating backup" >> /proc/1/fd/1
tar -czf "${target_dir}/${backup_name}.tar.gz" ${source_dir} >> /proc/1/fd/1

# check if the backup creation was successful
if [ $? -ne 0 ]; then
  echo "[${timestamp}] Error: Backup creation failed" >> /proc/1/fd/1
  exit 1
fi

# restart stopped containers
echo "[${timestamp}] Restaring stopped containers" >> /proc/1/fd/1
docker restart $(docker ps -q --filter label=dockup-backup-stop=true --filter "status=exited")

echo "[${timestamp}] Backup completed successfully" >> /proc/1/fd/1