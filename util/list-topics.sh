#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <bootstrap-server>"
    exit 1
fi

docker run --rm -it apache/kafka:3.9.1 /opt/kafka/bin/kafka-topics.sh --list --bootstrap-server "$1"
