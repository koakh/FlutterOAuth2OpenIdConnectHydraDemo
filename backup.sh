#!/bin/bash

DT=$(date +%Y-%m-%d-%H-%M)
DIR=.bak
FILE="$DIR/$DT.tgz"
FILE_EXCLUDE=exclude.tag
mkdir -p $DIR
touch .bak/$FILE_EXCLUDE

tar -czvf --exclude-tag-all=$FILE_EXCLUDE $FILE .
# tar -czvf $FILE .
