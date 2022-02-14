`sudo yum install logstash`

configuration directory
`/etc/logstash/conf.d/`

pull down and extract preconfigured files
`cd /etc/logstash/`
`sudo curl -L -O http://192.168.2.20/share/logstash.tar`
`sudo tar -xvf ./logstash.tar` will overwrite contents ./conf.d"

server configuration
`sudo /etc/logstash/logstash.yml`

###logstash functions
input
filter
output

logstash pipeline configuration
`/etc/logstash/conf.d/`
name files in a manner to force loading in desired sequence, and specify function
example
```
logstash-100-input-kafka-fsf.conf
logstash-498-filter-beat-cleanup.conf
logstash-499-filter-rock-environment.conf
logstash-500-filter-fsf.conf
logstash-9999-output-elasticsearch.conf
```

Logstash compiles all files in /etc/logstash/conf.d/ into a single runtime file.

###Input example
```
input {
  kafka {
    topics => ["zeek-raw"]
    add_field => { "[@metadata][stage]" => "zeek_json" }
    # Set this to one per kafka partition to scale up
    #consumer_threads => 4
    group_id => "zeek_logstash"
    bootstrap_servers => "127.0.0.1:9092"
    codec => json
    auto_offset_reset => "earliest"
    id => "input-kafka-zeek"
  }
}
```
"group_id should be common among nodes working the same task (cluster members)"

###Filter example (normalize data for elastic)
```
filter {

  if [@metadata][stage] == "zeek_json" {

    mutate {
      # Add ECS Event fields and fields ahead of time that we need but may not exist
      add_field => {
        "[event][module]" => "zeek"
        "[event][created]" => "%{[@timestamp]}"
        "[event][version]" => "1.0.0"
        "[related][id]" => []
        "[related][ip]" => []
        "[related][domain]" => []
      }
      rename => {
        "@stream" => "[event][dataset]"
        "@system" => "[observer][hostname]"
        "@proc"   => "[observer][sub_process]"
      }
      replace => { "[@metadata][stage]" => "zeek_category" }
    }
```
###Output example
```
output {
  stdout { codec => json }
  # Requires event module and category
  if [event][module] and [event][category] {

    # Requires event dataset
    if [event][dataset] {
      elasticsearch {
          hosts => [ "127.0.0.1" ]
          index => "ecs-%{[event][module]}-%{[event][category]}-%{+YYYY.MM.dd}"
          manage_template => false
      }
    }

    else {
      # Suricata or Zeek JSON error possibly, ie: Suricata without a event.dataset seen with filebeat error, but doesn't have a tag
      if [event][module] == "suricata" or [event][module] == "zeek" {
        elasticsearch {
            hosts => [ "127.0.0.1" ]
            index => "parse-failures-%{+YYYY.MM.dd}"
            manage_template => false
        }
      }
```
