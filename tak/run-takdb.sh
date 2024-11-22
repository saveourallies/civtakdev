#!/bin/bash

docker run -d \
  --env-file .env \
  -v tak_db:/var/lib/postgresql/data:z \
  -v $(pwd)/server/tak:/opt/tak:z \
  -p 5432:5432 \
  --network takserver \
  --network-alias tak-database \
  --name takserver-db \
  --rm takserver-db:"$(cat server/tak/version.txt)"
