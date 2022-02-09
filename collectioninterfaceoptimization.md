`scp student@192.168.2.20:/repos/configs/interface_prep.sh`
`sudo chmod +x interface_prep.sh`
`sudo ./interface_prep enp5s0`
## optimization script
```
#!/bin/bash
  for i in rx tx sg tso ufo gso gro lro rxvlan txvlan
    do
      /usr/sbin/ethtool -K $1 $i off
  done

/usr/sbin/ethtool -N $1 rx-flow-hash udp4 sdfn
/usr/sbin/ethtool -N $1 rx-flow-hash udp6 sdfn
/usr/sbin/ethtool -n $1 rx-flow-hash udp6
/usr/sbin/ethtool -n $1 rx-flow-hash udp4
/usr/sbin/ethtool -C $1 rx-usecs 10
/usr/sbin/ethtool -C $1 adaptive-rx off
/usr/sbin/ethtool -G $1 rx 4096

/usr/sbin/ip link set dev $1 promisc on
```

## display current settings
`ethtool -k <interface>`


## ifup-local script
```
#!/bin/bash
if [[ "$1" == "enp5s0" ]]
then
  for i in rx tx sg tso ufo gso gro lro rxvlan txvlan
    do
      /usr/sbin/ethtool -K $1 $i off
  done

/usr/sbin/ethtool -N $1 rx-flow-hash udp4 sdfn
/usr/sbin/ethtool -N $1 rx-flow-hash udp6 sdfn
/usr/sbin/ethtool -n $1 rx-flow-hash udp6
/usr/sbin/ethtool -n $1 rx-flow-hash udp4
/usr/sbin/ethtool -C $1 rx-usecs 10
/usr/sbin/ethtool -C $1 adaptive-rx off
/usr/sbin/ethtool -G $1 rx 4096

/usr/sbin/ip link set dev $1 promisc on

fi
```
## persistence of settings
`sudo scp student@192.168.2.20:/repos/configs/ifup-local /sbin/ifup-local`
`sudo chmod +x /sbin/ifup-local`
`ll /sbin/ifup-local` verify ownership is root:root
`sudo chown root:root /sbin/ifup-local` change ownership if needed


## modify scripts to run ifup-local
`sudo vi /etc/sysconfig/network-scripts/ifup`
append to file:
```
if [ -x /sbin/ifup-local ]; then
    /sbin/ifup-local ${DEVICE]
fi
```
## configure interface
`sudo vi /etc/sysconfig/network-scripts/ifcfg-enp5s0`
verify settings match below
```
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=none
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=no
IPV6_DEFROUTE=no
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp5s0
UUID=5ed60a2e-fd5f-4901-8be4-d7e75bda4558
DEVICE=enp5s0
ONBOOT=yes
```


## random
research implementation of checksumming and segmentation offloading
