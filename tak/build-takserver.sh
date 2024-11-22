#!/bin/bash

docker build \
    -t takserver:"$(cat server/tak/version.txt)" \
    -f server/docker/Dockerfile.takserver \
    server
