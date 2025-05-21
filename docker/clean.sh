#!/bin/bash

set -e

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

IDS=$(docker ps -aq --filter "name=kafka-")
docker kill $IDS || true
docker rm $IDS

rm -rf ./data/
