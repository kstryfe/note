# Zeek protocol independent network analyzer (formerly BRO)
`sudo yum install zeek zeek-plugin-kafka zeek-plugin-af_packet`
`/opt/zeek/etc` Possible alternate config location
`/etc/zeek` default config location


## define ip spaces
`sudo vi /etc/zeek/networks.cfg`

## general configuration
`sudo vi /etc/zeek/zeekctl.cfg`
"LogRotationInterval" set to "0" to disable logging (logging only needed for setup troubleshooting as kafka collects logs instead in production scenario)

"SitePolicyScripts" defines site specific policy scripts for customization

"LogDir" defines default log location if logging enabled (update to point to /data/zeek)
to verify  zeek functionality look for log output in `/data/zeek/current` logs strart in `/current` and get rotated to timestamped directories.

"SpoolDir" defines spool folder (can be optionally set to separate partition/drive)

"CfgDir" defines location of configuration files

append
`lb_custom.InterfacePrefix=af_packet::` to enable using af_packet

## clustering configuration / CPU pinning
`sudo vi /etc/zeek/node.cfg`

comment out standalone configuration

logger is optional

manager collects logs from load balanced workers and produces a single log file for kafka ingestion

proxy coordinates workers for peer to peer communication to offload workloads from manager

"env_vars=fanout_id=XX" arbitrary number to identify af_packet fanout instance

"lb_procs" defines number of threads

"pin_cpus" defines cores to pin to


example config for cluster config
```
# Example ZeekControl node configuration.
#
# This example has a standalone node ready to go except for possibly changing
# the sniffing interface.

# This is a complete standalone configuration.  Most likely you will
# only need to change the interface.
#[zeek]
#type=standalone
#host=localhost
#interface=eth0

## Below is an example clustered configuration. If you use this,
## remove the [zeek] node above.

#[logger]
#type=logger
#host=localhost
#
[manager]
type=manager
host=localhost
pin_cpus=3
#
[proxy-1]
type=proxy
host=localhost
#
[worker-1]
type=worker
host=localhost
interface=enp5s0
lb_method=custom
lb_procs=2
pin_cpus=1,2
env_vars=fanout_id=93
#
#[worker-2]
#type=worker
#host=localhost
#interface=eth0
```


## CPU pinning
`lscpu -e` efficient way to list cores

### DO NOT pin socket 0,core 0 or its' hyperthreaded counterpart
### DO NOT pin to both physical core and hyperthreaded version of that same core.
```
CPU NODE SOCKET CORE L1d:L1i:L2:L3 ONLINE MAXMHZ    MINMHZ
0   0    0      0    0:0:0:0       yes    4200.0000 800.0000
1   0    0      1    1:1:1:0       yes    4200.0000 800.0000
2   0    0      2    2:2:2:0       yes    4200.0000 800.0000
3   0    0      3    3:3:3:0       yes    4200.0000 800.0000
4   0    0      0    0:0:0:0       yes    4200.0000 800.0000
5   0    0      1    1:1:1:0       yes    4200.0000 800.0000
6   0    0      2    2:2:2:0       yes    4200.0000 800.0000
7   0    0      3    3:3:3:0       yes    4200.0000 800.0000
```
in above example you could select "CPU 1" OR "CPU 5" not both, "CPU 2" OR "CPU 6" not both, etc.

## zeek scripts
file path
`/usr/share/zeek/`

`/usr/share/zeek/site/local.zeek` local zeek script configuration, append additional scripts to be loaded as shown below
`sudo mkdir /usr/share/zeek/site/scripts`
`cd /usr/share/zeek/site/scripts`


`sudo curl -L -O http://192.168.2.20/share/afpacket.zeek`
`sudo vi afpacket.zeek` script references "fanout_id" specified in /etc/zeek/node.cfg

`sudo curl -L -O http://192.168.2.20/share/extension.zeek` supports tagging streams based on sensor

`sudo curl -L -O http://192.168.2.20/share/extract-files.zeek` support file extraction from streams

`sudo curl -L -O http://192.168.2.20/share/fsf.zeek` support file extraction from streams

`sudo curl -L -O http://192.168.2.20/share/json.zeek` format zeek logs in JSON format

`sudo curl -L -O http://192.168.2.20/share/kafka.zeek` log to kafka (update metadata.broker.list)

example
```
@load Apache/Kafka/logs-to-kafka

redef Kafka::topic_name = "zeek-raw";
redef Kafka::json_timestamps = JSON::TS_ISO8601;
redef Kafka::tag_json = F;
redef Kafka::kafka_conf = table(
    ["metadata.broker.list"] = "localhost:9092");

event zeek_init() &priority=-5
{
    for (stream_id in Log::active_streams)
    {
        if (|Kafka::logs_to_send| == 0 || stream_id in Kafka::logs_to_send)
        {
            local filter: Log::Filter = [
                $name = fmt("kafka-%s", stream_id),
                $writer = Log::WRITER_KAFKAWRITER,
                $config = table(["stream_id"] = fmt("%s", stream_id))
            ];

            Log::add_filter(stream_id, filter);
        }
    }
}
```
### local.zeek config

`sudo vi /usr/share/zeek/site/local.zeek`
append
```
@load scripts/afpacket.zeek
@load scripts/extension.zeek
@load scripts/extract-files.zeek
@load scripts/fsf.zeek
@load scripts/json.zeek
@load scripts/kafka.zeek
```


## start zeek
`sudo zeekctl deploy` reloads gracefully and reparses config and scripts
`sudo zeekctl start` starts any stopped instances, already running instances do not reparse configs
`sudo zeekctl status` display zeek status

## verify zeek functionality with fsf
`ls /data/zeek/extract_files/`
`tail /data/fsf/rockout.log`

##notes
- zeek CAN autopin cores but it is not efficient on larger systems and benefits from manual pinning to force it to use the resources available
- general rule of thumb is 1 core per 180Mbps (official number is 250Mbps)
- Hyperthreading conflict if pinning to multiple hyperthread cores on same core (will crash zeek) use one per core
- zeek runs as root by default, but can be configured to run as a zeek user with some additional system configuration
