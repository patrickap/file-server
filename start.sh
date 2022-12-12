#!/bin/bash

# create zones
sh ./coredns/create_zones.sh

# start containers
docker-compose up -d