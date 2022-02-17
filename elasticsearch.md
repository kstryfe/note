`sudo yum install elasticsearch`

`cd /data`
`sudo chown -R elasticsearch:elasticsearch /data/elasticsearch`
`sudo vi /etc/elasticsearch/elasticsearch.yml`
`set nu`
`:17` `cluster.name: SG-3`
`:23` `node.name: node-1` something useful
`:27` node.rack.
`:55` `network.host: _local:ipv4_` shortcut to bind to local IP, can also be specific.
`sudo mkdir /usr/lib/systemd/system/elasticsearch.service.d`
`sudo chmod 755 /usr/lib/systemd/system/elasticsearch.service.d`
`sudo vi /usr/lib/systemd/system/elasticsearch.service.d/override.conf`
file contents
```
[Service]
LimitMEMLOCK=infinity
```
`sudo chmod 644 /usr/lib/systemd/system/elasticsearch.service.d/override.conf`
`/sudo vi /etc/elasticsearch/jvm.options`
`set nu`
`:22` `-Xms4g` initial heap size
`:23` `-Xms4g` max heap size (half of RAM up to 31G)


`sudo firewall-cmd --add-port={9200,9300}/tcp --permanent`
`sudo firewall-cmd --reload`

`sudo systemctl start elasticsearch`
`sudo systemctl status elasticsearch`

## test
`curl localhost:9200/_cat/nodes?v` "?v" adds headers "?pretty" is an option for some outputs.
`curl localhost:9200/_cat/indices`

## Architecture
CLUSTER>NODE>INDICES>SHARD/REPLICA>DOCUMENTS

## cluster


## node
- odd number recommended
- Undefined nodes will assume ALL roles unless otherwise configured.(NOT OPTIMAL)
- Node roles (Master, Data, Ingest, Coordination, Machine Learning,   )
- Master Node (task manager, low resource requirement, only 1 technically needed) (primary master identified via election process)
- Data Node (resource intensive)
- Ingest Node (primarily used in instances where filebeat is not available, also used for re-ingestion of data)
- Coordination Node (handles distributed queries from kibana in large clusters, low resource utilization, only 1 technically needed, can be colocated on master node, standalone mainly needed for 20+ data node clusters)
- Machine Learning Node (very resource intensive, not necessary to be always online, can be spun up for task specific functions and spun down.) (Platinum license or XPack required to access) (anomaly detection)
-dilmrt (Data,Ingest,machine Learning, Remote cluster agent, Transform)
## Indices


## Shard
- parts of a document
- single lucene instance

## Replica
- warm failover instance of a shard

## Document
