#!/usr/bin/env bash

###################################################################
# Main
###################################################################

docker-compose down
docker-compose pull
docker-compose build
docker-compose up -d
