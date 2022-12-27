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

6. backups are created automatically but manual backups are supported

```bash
# create manual backup
docker exec <backup_container_name> backup
```
