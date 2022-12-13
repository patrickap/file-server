# file-server

Private file serve including dns server and reverse proxy. 📁

### Getting started

0. install dependencies

```bash
# update package index
sudo apt-get update

# install docker dependencies
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# install docker gpg key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# setup docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# update package index
sudo apt-get update

# install docker-compose
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

# enable non-root user to execute docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# install rclone
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

1. rename all `filename.example`files to `filename` and set all required values.

2. start containers

```bash
docker-compose up -d
```

3. setup rclone backup

```bash
rclone config
```

4. add backup cronjob

```bash
crontab -e

# backup data every day at 3am using rclone
0 3 * * * (rclone copy <config_name>:<remote_path> <local_path>)
```
