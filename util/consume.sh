#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <topic> <bootstrap-server>"
    exit 1
fi

docker run --rm -it apache/kafka:3.9.1 /opt/kafka/bin/kafka-console-consumer.sh --topic "$1" --from-beginning --bootstrap-server "$2"
