#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# automatically export all variables
set -a
source ${SCRIPT_DIR}/.env
set +a

# create zone cloud.local
envsubst '${HOST_IP}' < ${SCRIPT_DIR}/db.cloud.local.template > ${SCRIPT_DIR}/db.cloud.local