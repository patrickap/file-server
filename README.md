# file-server

Private file serve including dns server and reverse proxy. 📁

# Getting started

0. install dependencies

- docker
- docker-compose
- rclone

2. setup rclone backup

```bash
rclone config
```

3. add backup cronjob

```bash
crontab -e

# backup data every day at 3am using rclone
0 3 * * * (rclone copy <config_name>:<remote_path> <local_path>)
```

4. start containers

```bash
sh ./start.sh
```
