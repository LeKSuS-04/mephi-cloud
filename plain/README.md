### Create a topic

```
/opt/kafka/bin/kafka-topics.sh --create --topic my-test-topic --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092
```

### List topics

```
/opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092
```

### Produce messages

```
/opt/kafka/bin/kafka-console-producer.sh --topic my-test-topic --bootstrap-server localhost:9092
```

### Consume messages

```
/opt/kafka/bin/kafka-console-consumer.sh --topic my-test-topic --from-beginning --bootstrap-server localhost:9092
```
