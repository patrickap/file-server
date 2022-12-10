#!/bin/bash

# create zones
sh coredns/create_zones.sh

# start containers
docker-compose up

# start backup cronjob
# TODO: backup ocis data via webdav using rclone