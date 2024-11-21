#!/bin/bash

# docs as code using Structurizr
docker run --name surveyor81 -it --rm -p 8081:8080 \
    -v ${PWD}:/usr/local/structurizr \
    structurizr/lite
