#!/bin/bash

# load env
set -a
source .env
set +a

# create dns zone from template
envsubst '${HOST_IP} ${HOST_NAME}' < .zone.template > .zone

# start containers
docker compose up -d