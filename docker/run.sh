#!/bin/bash

set -e

KAFKA_VERSION="3.9.1"
CONTAINER_NAME="kafka-$(date +%s)"

docker run -d --name $CONTAINER_NAME \
  -p 10092:9092 \
  -v ./data:/opt/kafka/log \
  apache/kafka:$KAFKA_VERSION
