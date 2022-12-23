#!/bin/bash

username=$SFTPGO_ACTION_USERNAME
filepath=$SFTPGO_ACTION_PATH
basename=$(basename -- "$filepath")

# if the filepath includes username/.trash the action
# was triggered inside the trash folder
if [[ "$filepath" == *"$username/.trash"* ]]; then
  # allow deletion and execute delete action
  exit 1
else
  # create trash folder if missing
  mkdir -p /srv/sftpgo/data/$username/.trash
  # move and increment identical filenames instead of overwriting them
  mv --backup=numbered $filepath /srv/sftpgo/data/$username/.trash/$basename
  # deny deletion and skip delete action
  exit 0  
fi
