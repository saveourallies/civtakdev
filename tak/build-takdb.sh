#!/bin/bash

docker build \
    -t takserver-db:"$(cat server/tak/version.txt)" \
    -f server/docker/Dockerfile.takserver-db \
    server
