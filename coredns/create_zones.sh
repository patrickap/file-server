#!/bin/bash

# automatically export all variables
set -a
source .env
set +a

# create zone cloud.local
envsubst '${HOST_IP}' < db.cloud.local.template > db.cloud.local