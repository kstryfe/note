



repo
192.168.2.20

## Rock NSM

network> NIC> suricata+ zeek+>kafka > logstash > elasticsearch> kibana

NIC> google stenographer>docket

zeek> fsf>kafka

FSF= "File Scanning Framework"

## PCAP focus
Google stenographer =high efficiency "pcap to disk" FIFO (largest non-distributed system load)


Docket + stenographer is sometimes replaced by moloch in some instances, but is higher resource load.

## Log generation for analysis
Suricata- IDS/IPS (running in IDS mode) Purpose is to catch "known bad" based on rules/signature, multithreaded (used to generate logs)

Zeek - Network protocol analyzer (Port independent protocol analyzer) categorizes traffic (resource intensive) (used to generate logs)


## File scanning framework (FSF)
offline suspect file scanning (generates yarra signatures) may be getting replaced by mitroska

## Kafka
messaging queuing engine necessary for scaling but not *technically* needed. (stores queue on disk so it is tolerant of power outages) decoupled input to output

## logstash
transform, enrich, concatenate, format, mutate, data before sending to elastic search

## Elasticsearch
Metadata datastore (indexes)
ML nodes interact directly with ES

## Kibana

UI For elasticsearch via REST API
 "Fleet" legacy implementation caused performance issues
