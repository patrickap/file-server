# file-server

Local file sync server with support for sftp, webdav, caldav and carddav. 📁

### Getting started

1. install `docker` and `docker compose` plugin

2. create an `.env` file and set the corresponding values

3. set target for backups in `docker-compose.yml`

```yml
...
backup:
  ...
  volumes:
    - /path/to/backup:/archive
    - /path/to/backup/tmp:/tmp
  ...
...
```

4. set up the local dns server on the router by entering the host ip

5. start the containers

```bash
docker compose up -d
```

6. backups are created automatically but can also be created manually

```bash
# create manual backup
docker exec <backup_container_name> backup
```

7. to access or copy backups available on the remote host `scp` can be used

```bash
scp username@<host_ip>:/path/to/source.tar.gz  /path/to/target
```

8. to restore a backup, a new volume with the correct name must be created including the contents of the backup

```bash
# stop all containers that are using the volume
docker stop <container_name>

# untar the backup
tar -C /tmp -xvf  backup.tar.gz

# use a temporary once-off container to mount the volume and copy the backup
# additional information can be found in the docs https://github.com/offen/docker-volume-backup#restoring-a-volume-from-a-backup
docker run -d --name <temporary_container_name> -v <volume_name>:/path/to/mount alpine
docker cp /tmp/backup/<volume_name> <temporary_container_name>:/path/to/mount
docker stop <temporary_container_name>
docker rm <temporary_container_name>

# start all stopped containers
docker start <container_name>
```
