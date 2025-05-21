#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <topic> <bootstrap-server>"
    exit 1
fi

/opt/kafka/bin/kafka-topics.sh --create --topic "$1" --bootstrap-server "$2"
