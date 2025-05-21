#!/bin/bash

set -ex

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

cp configs/server.properties /opt/kafka/config/server.properties
chown kafka:kafka /opt/kafka/config/server.properties
systemctl restart kafka
