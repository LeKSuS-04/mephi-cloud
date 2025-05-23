#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

echo "Installing dependencies"
apt-get update -y
apt-get install -y default-jre


if ! id "kafka" &>/dev/null; then
    echo "Creating kafka user"
    useradd -m -s /bin/bash kafka
else
    echo "kafka user already exists"
fi

VERSION="3.9.1"
echo "Downloading Kafka v$VERSION"

pushd /opt
wget https://dlcdn.apache.org/kafka/$VERSION/kafka_2.13-$VERSION.tgz
tar -xzf kafka_2.13-$VERSION.tgz
rm kafka_2.13-$VERSION.tgz
ln -sf kafka_2.13-$VERSION kafka
mkdir -p kafka/data
mkdir -p kafka/logs
popd

echo "Copying configuration"
cp configs/server.properties /opt/kafka/config/server.properties

echo "Formatting directories"
/opt/kafka/bin/kafka-storage.sh random-uuid > /opt/kafka/cluster_id
/opt/kafka/bin/kafka-storage.sh format -t "$(cat /opt/kafka/cluster_id)" -c /opt/kafka/config/server.properties

echo "Setting ownership"
chown -R kafka:kafka /opt/kafka_2.13-$VERSION

echo "Starting systemd service"
cp systemd/kafka.service /etc/systemd/system/kafka.service
systemctl daemon-reload
systemctl start kafka
systemctl enable kafka

