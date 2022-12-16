#!/bin/bash

read -p "enter source path: " SOURCE_PATH
read -p "enter target path: " TARGET_PATH

readonly DATE_TIME="$(date '+%Y-%m-%d_%H-%M-%S')"
readonly LATEST_SYMLINK="${TARGET_DIR}/latest"

# create target dir
mkdir -p "${TARGET_DIR}"

# create backup from symlinks
rsync -av --delete \
  "${SOURCE_PATH}/" \
  --copy-links  \
  --link-dest "${LATEST_SYMLINK}" \
  "${TARGET_DIR}/${DATE_TIME}"

# update latest symlink
rm -rf "${LATEST_SYMLINK}"
ln -s "${TARGET_DIR}/${DATE_TIME}" "${LATEST_SYMLINK}"
