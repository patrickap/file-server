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
    - ./<path_to_target>:/archive
    - ...
  ...
...
```

4. enable the local dns server on the router by entering the host ip

5. start the containers

```bash
bash start.sh
```

6. backups are created automatically

```bash
# create manual backup
docker exec file-server-backup backup
```
