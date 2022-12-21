# file-server

Local file sync server with support for sftp, webdav, caldav and carddav. 📁

### Getting started

1. install `docker` and `docker compose` plugin

2. create an `.env` file and set the corresponding values

3. start the containers

```bash
bash start.sh
```

4. create manual backups (optional)

```bash
docker exec file-server-backup backup
```
