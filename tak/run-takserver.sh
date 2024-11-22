#!/bin/bash

# note this shares the tak folder with the docker container.

docker run -d \
    --env-file .env \
    -v $(pwd)/server/tak:/opt/tak:z \
    -p 8089:8089 \
    -p 8443:8443 \
    -p 8444:8444 \
    -p 8446:8446 \
    -p 9000:9000 \
    -p 9001:9001 \
    --network takserver \
    --name takserver \
    --rm takserver:"$(cat server/tak/version.txt)"
