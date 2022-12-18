#!/bin/bash

# load env
set -a
source .env
set +a

# create dns zone for self-cloud.com
envsubst '${HOST_IP}' < db.self-cloud.com.template > db.self-cloud.com

# start containers
docker compose up -d