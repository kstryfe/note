`scp student@192.168.2.20:/repos/interface_prep.sh`
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
