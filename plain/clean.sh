#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

echo "Stopping kafka service"
systemctl stop kafka
systemctl disable kafka

echo "Removing kafka user"
userdel -r kafka

echo "Removing kafka directory"
rm -rf /opt/kafka*
