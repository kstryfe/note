# Zeek protocol independent network analyzer (formerly BRO)
`sudo yum install zeek zeek-plugin-kafka zeek-plugin-af_packet`
`/opt/zeek/etc` Possible alternate config location
`/etc/zeek` default config location


## define ip spaces
`sudo vi /etc/zeek/networks.cfg`

## general configuration
`sudo vi /etc/zeek/zeekctl.cfg`
"LogRotationInterval" set to "0" to disable logging (logging only needed for setup troubleshooting as kafka collects logs instead)

"SitePolicyScripts" defines site specific policy scripts for customization

" LogDir" defines default log location if logging enabled (update to point to /data/zeek)

"SpoolDir" defines spool folder (can be optionally set to separate partition/drive)

"CfgDir" defines location of configuration files

append
`lb_custom.InterfacePrefix=af_packet::` to enable using af_packet

## clustering configuration / CPU pinning
`sudo vi /etc/zeek/node.cfg`


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

##notes
- zeek CAN autopin cores but it is not efficient on larger systems and benefits from manual pinning to force it to use the resources available
- general rule of thumb is 1 core per 180Mbps (official number is 250Mbps)
- Hyperthreading conflict if pinning to multiple hyperthread cores on same core (will crash zeek) use one per core
