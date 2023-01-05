# file-server

Local file sync server with support for sftp, webdav, caldav and carddav. 📁

### Requirements

To run this application the following is needed:

- [linux server](https://ubuntu.com/download/server) (Ubuntu Server 22.04 LTS is tested and recommended)
- [docker](https://docs.docker.com/engine/install/ubuntu/) and [docker compose plugin](https://docs.docker.com/compose/install/linux/)
- router with possibility of configuring a custom DNS

### Installation and host configuration

Clone this repository using `git clone https://github.com/patrickap/file-server.git`

An `.env` configuration file is required and must be created manually. The content can be derived from the `.env.example` in the root directory.

The `docker.compose.yml` must be adapted to your own needs. The relevant parts are marked with `TODO: ...`. This is especially important for backups. Please refer to the corresponding section.

Some of the containers need internet access to install their packages. For this to work the DNS used by the docker daemon must be configured correctly. It is also possible to specify a custom docker root. This is especially useful if the data of the volumes needs to be stored on a different disk. To edit or create the configuration for the first time type `nano /etc/docker/daemon.json`.

```json
{
  "data-root": "/path/to/docker-root",
  "dns": ["8.8.8.8"]
}
```

Before going further you should adjust your router to use your own DNS service. Otherwise the services are not reachable by their domain name. The DNS service is available under `<host_ip>:53`.

### Server startup

To start simply run the containers detached in the background.

```bash
docker compose up -d
```

### Server configuration

In order to access the services on the local network through a secure connection (without warnings), it is necessary to install the root certificate on all devices. The certificate can be downloaded here: `https://certificate.<host_name>`.

To manage running and new containers open `https://portainer.<host_name>` or `<host_ip>:9000`. At the beginning an admin user must be created. Further information: [Portainer Docs](https://docs.portainer.io)

The calendar and contacts server is available under `https://radicale.<host_name>` or `<host_ip>:9800`. Users can be created as desired. Further information: [Radicale Docs](https://radicale.org/v3.html)

The file server itself can be reached via `https://sftpgo.<host_name>` or `<host_ip>:9200`. The users can be created at this time. If calendars and contacts should be displayed as virtual folder it is required the add the pre-configured group `RadicaleGroup`. For a correct mapping it is also necessary that the usernames of both services match. Further information: [SFTPGo Docs](https://github.com/drakkan/sftpgo/tree/main/docs)

- access via WebDAV: `https://webdav.sftpgo.<host_name>` or `<host_ip>:9400`
- access via SFTP: `https://sftpgo.<host_name>` or `<host_ip>:9600`

### Server backup management

To access the backups outside Docker it is necessary to make them available to the host using bind mounts. To copy backups automatically to the cloud, a job must be specified in the lifecycle hook using a label. It is recommended to use `rclone` since it is installed by default. After the containers have been started, the configuration must be created within the `backup_remote` container using the `rclone config` command. For performance reasons a [custom client-id](https://rclone.org/drive/#making-your-own-client-id) should be created when using Google Drive. In order to not fill up the cloud storage unnecessarily it is also a good idea to disable the trash in the advanced configuration.

```yml
...
backup_local:
  ...
  volumes:
    # bind mount the backup volumes to a custom location
    - /path/to/backup:/archive
    - /path/to/backup/tmp:/tmp
  ...
backup_remote:
  ...
  labels:
    # backup data to a cloud using rclone
    - docker-volume-backup.copy-post=/bin/sh -c 'rclone purge remote:backup ; rclone copy $$COMMAND_RUNTIME_ARCHIVE_FILEPATH remote:backup'
  ...
...
```

Backups are created automatically (local daily, remote weekly) but can also be created manually.

```bash
# create manual backup
docker exec <backup_local_container> backup
docker exec <backup_remote_container> backup
```

To access or copy backups available on the remote host the command-line tool `scp` can be used.

```bash
scp username@<host_ip>:/path/to/source.tar.gz /path/to/target
```

To restore a backup a new volume with the correct name must be created including the contents of the backup.

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

Further information: [offen/docker-volume-backup Docs](https://github.com/offen/docker-volume-backup)

### Server updates

If something in `docker-compose.yml` changes it is usually sufficient to restart the containers. However, sometimes it may be necessary to update image versions. In this case it is necessary to rebuild the containers.

```bash
# update
docker compose up -d

# update and rebuild
docker compose up -d --build <optional_service_name>
```
