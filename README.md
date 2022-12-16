# file-server

Private file serve including dns server and reverse proxy. 📁

### Getting started

1. install the dependencies

```bash
bash install.sh
```

2. create an `.env` file and set the corresponding values

3. start the containers

```bash
bash start.sh
```

4. create a manual backup

```bash
bash backup.sh
```

5. create backups regularly

```bash
crontab -e

# backup data every day at 3am
0 3 * * * (echo $SOURCE_PATH $TARGET_PATH | bash backup.sh)
```
