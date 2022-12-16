#!/bin/bash

# load env
set -a
source .env
set +a

# create folders and permissions for bind mounts
sudo mkdir -p data/sftpgo data/radicale
sudo chown -R 1000:1000 data/sftpgo
sudo chown -R 2999:2999 data/radicale

# create dns zone for cloud.local
envsubst '${HOST_IP}' < db.cloud.local.template > db.cloud.local

# start containers
docker compose up -d