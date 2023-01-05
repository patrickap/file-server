# file-server

Local file sync server with support for sftp, webdav, caldav and carddav. 📁

### Getting started

1. Install `docker` and the `docker compose` plugin.

2. The Docker Daemon must be configured by creating or updating the `/etc/docker/daemon.json`. Since a DNS Service is running, there must be an explicit DNS entry to be able to access the internet from within the containers. In addition another directory or can be defined for the docker root. This is useful for storing the volume data on a different drive.

```json
{
  "data-root": "/path/to/docker-root",
  "dns": ["8.8.8.8"]
}
```

3. Create an `.env` file using the `.env.example` and set the corresponding values.

4. Set the target and temporary path for backups in the `docker-compose.yml`.

```yml
...
backup_local:
  ...
  volumes:
    - /path/to/backup:/archive
    - /path/to/backup/tmp:/tmp
  ...
...
```

5. Set up and enable the local dns server on the router.

6. Start the containers in the background.

```bash
docker compose up -d
```

7. The services are available as follows:

- coredns
  - <host_ip>:53
- caddy
  - <host_ip>:443
- portainer
  - <host_ip>:9000
  - https://portainer.<host_name>
- sftpgo (http)
  - <host_ip>:9200
  - https://sftpgo.<host_name>
- sftpgo (webdav)
  - <host_ip>:9400
  - https://webdav.sftpgo.<host_name>
- sftpgo (sftp)
  - <host_ip>:9600
  - https://sftpgo.<host_name>
- radicale (http, caldav, carddav)
  - <host_ip>:9800
  - https://radicale.<host_name>
- certificate (root ssl/tls certificate download)
  - https://certificate.<host_name>

8. At this point the individual users for each service can be created. There is a pre-configured user group in SFTPGo which makes it possible to reference the CalDav and CardDav data from Radicale. The only requirement is that the user names of both services match and the group `RadicaleGroup` has been set in the user settings of SFTPGo.

9. Backups are created automatically (local daily, remote weekly) but can also be created manually.

```bash
# create manual backup
docker exec <backup_local> backup
docker exec <backup_remote> backup
```

10. Uploading backups to a cloud is supported using rclone. Configure a remote using `rclone config` inside the `backup_remote` container and set up the upload script in the `docker-compose.yml`

```yml
...
backup_remote:
  ...
  labels:
    - docker-volume-backup.copy-post=/bin/sh -c 'rclone purge remote:backup ; rclone copy $$COMMAND_RUNTIME_ARCHIVE_FILEPATH remote:backup'
  ...
...
```

11. Encrypting backups during creation is possible with `gpg` by setting the `GPG_PASSPHRASE` as argument or environemnt variable.

12. To access or copy backups available on the remote host the command-line tool `scp` can be used.

```bash
scp username@<host_ip>:/path/to/source.tar.gz  /path/to/target
```

13. To restore a backup a new volume with the correct name must be created including the contents of the backup. Additional information can be found in the docs of docker-volume-backup: https://github.com/offen/docker-volume-backup#restoring-a-volume-from-a-backup

```bash
# stop all containers that are using the volume
docker stop <container_name>

# untar the backup
tar -C /tmp -xvzf backup.tar.gz

# use a temporary once-off container to mount the volume and copy the backup
docker run -d --name <temporary_container_name> -v <volume_name>:/path/to/mount alpine
docker cp /tmp/backup/<volume_name> <temporary_container_name>:/path/to/mount
docker stop <temporary_container_name>
docker rm <temporary_container_name>

# start all stopped containers
docker start <container_name>
```
