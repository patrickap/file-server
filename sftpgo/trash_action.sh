#!/bin/bash

username=$SFTPGO_ACTION_USERNAME
filepath=$SFTPGO_ACTION_PATH
filename=$(basename -- "$filepath")

# TODO: handle file vs folder deletion
# TODO: fix files inside trash can't be deleted

mkdir -p /srv/sftpgo/data/${username}/.trash

# the --backup flag increments identical filenames instead of overwriting them
mv --backup=t ${filepath} /srv/sftpgo/data/${username}/.trash/${filename}

exit 0
