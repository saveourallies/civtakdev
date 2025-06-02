#!/bin/bash

rm -rf public

# run build script
./build.sh

rsync -avz --delete --progress public/* opeongo:~/civtakdoc
