#!/bin/bash

# load env
set -a
source .env
set +a

# create dns zone from template
envsubst '${HOST_IP} ${HOST_NAME}' < db.domain.tld.template > db.domain.tld

# start containers
docker compose up -d