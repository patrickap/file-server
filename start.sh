#!/bin/bash

# load env
set -a
source .env
set +a

# create dns zone for cloud.local
envsubst '${HOST_IP}' < db.cloud.local.template > db.cloud.local

# start containers
docker compose up -d