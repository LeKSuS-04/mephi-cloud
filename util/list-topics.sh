#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <bootstrap-server>"
    exit 1
fi

/opt/kafka/bin/kafka-topics.sh --list --bootstrap-server "$1"
