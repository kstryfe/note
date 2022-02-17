## FIPS STIG breaks Zeek
## Kafka does not play well with ipv6

## examples

left of kafka baremetal (zeek, suricata, stenographer)
right of kafka as well as kafka virtualized/containerized


## terminology
"5 tuple"
"elastic snapshot"
"hot, warm, cold, frozen"
"Machine learning attribute"
"Machine learning nodes"
"Machine learning node manager"
"Dedicated machine learning nodes"
"kubernetes dynamic ML nodes (on demand, spin up, run, spin down)"


Cluster>Node>Index>Shard


Elasticsearch has a max RAM limit per node of <32G ram due to a Java limitation (same as minecraft)
docker swarm (deprecated)/kubernetes reccomended for node management.


Remote full stack is preferred solution to small pipe scenarios. "Cross-cluster Search" is utilized to query data quickly and efficiently. Primary concern is local storage space and retention.All local logging to disk is disabled and a large kafka store is allocated.


Option 2 is to have a remote kafka cluster colocated with all the collection tools and have it feed back to the main Logstash
(benefit is central location of single elasticsearch instance)
## mass Firewall
`sudo firewall-cmd --add-port={1234,9200,9300,5800,9092,2181,2182,2183,5601}/tcp`
## mass install
`sudo yum install stenographer kafka librdkafka zookeeper elasticsearch zeek zeek-plugin-kafka zeek-plugin-af_packet filebeat fsf kibana suricata logstash`
quick and dirty status script
```
#!/bin/bash
systemctl status stenographer | grep 'Active:'
systemctl status suricata | grep 'Active:'
systemctl status kafka | grep 'Active:'
systemctl status zookeeper | grep 'Active:'
systemctl status fsf | grep 'Active:'
systemctl status filebeat | grep 'Active'
systemctl status logstash | grep 'Active'
systemctl status elasticsearch | grep 'Active'
systemctl status kibana | grep 'Active'
zeekctl status
```

## troubleshooting tip
`ls -ltc` list files by modification time
to override self signed cert issues in chrome type "thisisunsafe" on the warning page.


Test items
- Zeek data seen in Kibana
- suricata data seen in Kibana
- FSF data seen in kibana
- Correctly configured partitions
- data in /data/stenographer/packets/
- selinux enabled (proper chown settings)
- services up and running
- index patterns
