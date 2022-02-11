## Kafka distributed messaging broker
`sudo yum install kafka librdkafka zookeeper`

## Kafka
supports buffering to manage load of consumers
buffers to disk for graceful recovery in event of power loss (minimal loss of data compared to RAM buffering)
Lag in presented data (i.e. last visible data is minutes old) may be an indicator of kafka playing catch up on the buffer
## producers
input (zeek, suricata, fsf)
publishes data to a topic
## consumers
output (logstash)
reads data from a topic
## topics
data stores separated by input/subject


## Kafka clustering
### nodes
contains partitions
### partitions
topic based instance (primary)
### replicas
redundant instance of a partition on a separate node (failover)


## kafka config

`/etc/kafka`

`sudo vi /etc/kafka/server.properties`
"broker.id" up to 3 digit id to identify the broker
```
# The id of the broker. This must be set to a unique integer for each broker.
broker.id=1
```

"listeners" address/port binding (leave "PLAINTEXT" alone)
```
listeners=PLAINTEXT://localhost:9092
```

"advertised.listeners" adress/port binding advertised to producers and consumers
```
advertised.listeners=PLAINTEXT://localhost:9092
```

"log.dirs" change to `/data/kafka/logs` (create "logs" subfolder)
```
# A comma separated list of directories under which to store log files
log.dirs=/data/kafka/logs
```

"log.retention.hours" how long kafka retains logs (reccomended to set to 3-4 days in production to account for outages without losing data)

"enable.zookeeper=true" enable zookeeper
"delete.topic.enable=true" allow zookeeper to delete topics
```
zookeeper.connect=localhost:2181
enable.zookeeper=true
delete.topic.enable=true
# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=6000
```


`sudo vi /usr/share/kafka/config/producer.properties`

"bootstrap.servers" specify kafka servers
"zookeeper.connect" specify zookeeper connection details (host/port)
```
bootstrap.servers=localhost:9092
zookeeper.connect=localhost:2181
```

`sudo vi /usr/share/kafka/config/consumer.properties`

"bootstrap.servers" specify kafka servers
"zookeeper.connect" specify zookeeper connection details (host/port)
"group.id" identifier for consumer group (string)

```
bootstrap.servers=localhost:9092
zookeeper.connect=localhost:2181
# consumer group id
group.id=test-consumer-group
```

`sudo chown -R kafka:kafka /data/kafka`
`sudo mkdir /data/kafka/logs`


`sudo firewall-cmd --add-port={9092,2181,2182,2183}/tcp --permanent`
`sudo firewall-cmd --reload`

### start zookeeper before kafka

`sudo systemctl start zookeeper`
`sudo systemctl status zookeeper`

### verify zookeeper is fully up and running before starting Kafka (not just service status)

``sudo systemctl start kafka`
`
example
```


## zookeeper
manages kafka nodes, partitions, and topics.  necessary for kafka operation (basically the kafka manager/master node)

configuration path
`/etc/zookeeper/`

`sudo vi /etc/zookeeper/zoo.cfg`

"dataDir" specifies data location for zookeeper.

"clientPort" specifies port, additional lines needed for cluster communication (master selection,etc)
example
```
clientPort=2181
server.1=localhost:2182:2183
```

### manual test
`/usr/share/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 8 --topic zeek-raw`
### troubleshooting
`sudo systemctl stop fsf`
`sudo zeekctl stop`
`/usr/share/kafka/bin/kafka-topics.sh --delete --zookeeper localhost:2181 --topic zeek-raw`
`/usr/share/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 8 --topic zeek-raw`
`/usr/share/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 8 --topic suricata-raw`
`/usr/share/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 8 --topic fsf-raw`
`sudo zeekctl start`
`sudo systemctl start fsf`

describe
`/usr/share/kafka/bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic zeek-raw` provides information on topic, blank reply means no data present (possible feed problem)

raw dump of topic (for troubleshooting, wall of text)
`/usr/share/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic zeek-raw` to test for incoming traffic
## notes
- kafka is not recommended to be co-located with sensors due to resource contention.
- in practice superior to directly feeding into logstash
- possible log4j concerns between zookeeper, elastic, etc.
- kafka will autocreate topics, but you can also specify topics
