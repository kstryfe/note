# PFSENSE notes
WAN DCHP (10.0.xx.2/30)
LAN 172.16.xx.1 /24
DHCP scope 100-254


## Firewall rules
WAN allow any,any


## NAT rules
Outbound NAT disabled


10.0.30/30
172.16.30.0/24
DHCP scope 172.16.30.100-254
Hostname SG30-PFSENSE

##PFSense Bridging
Interface assignment> assign OPT interface> enable >Interface assignment > bridging> assign interfaces
