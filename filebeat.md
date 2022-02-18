## Filebeat Log shipper (ships log files into kafka)

## ships FSF and Suricata logs to Kafka (zeek does not need it)
`sudo yum install filebeat`
Configuration folder
`/etc/filebeat`

Reference yml file
`sudo less /etc/filebeat/filebeat.reference.yml`

rename default to backup
`sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.bk`


`cd /etc/filebeat/`
`curl -L -O http://192.168.2.20/share/filebeat.yml`

example
```
#=========================== Filebeat prospectors =============================
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /data/suricata/eve.json
    json.keys_under_root: true
    fields:
      kafka_topic: suricata-raw
    fields_under_root: true
  - type: log
    enabled: true
    paths:
      - /data/fsf/rockout.log
    json.keys_under_root: true
    fields:
      kafka_topic: fsf-raw
    fields_under_root: true
processors:
  - decode_json_fields:
      fields:
        - message
        - Scan Time
        - Filename
        - objects
        - Source
        - meta
        - Alert
        - Summary
      process_array: true
      max_depth: 10
#================================ Outputs =====================================
output.kafka:
  hosts: ["localhost:9092"]

  topic: '%{[kafka_topic]}'
  required_acks: 1
  compression: gzip
  max_message_bytes: 1000000

#================================== Error Logging ==============================
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644
```

## troubleshooting
`sudo /usr/share/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic suricata-raw --from-beginning` to show output from filebeats as configured.
`sudo /usr/share/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic fsf-raw --from-beginning` critical to use "--from-beginning" for fsf as files are not steadily flowing across the network and you may miss the traffic.

##notes
- you always want a message queue between feeds and elastic (kafka is a message queue)
- /var/log/filebeat contains filebeat logging for troubleshooting
