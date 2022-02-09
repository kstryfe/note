`sudo yum install suricata`
`sudo vi /etc/suricata/suricata.yaml`
###VI shortcuts for the suricata config
`:set nu` display line numbers
`:56` jump to line 56 to configure log directory
`:60` jump to line 60 to disable stats collection
`:76` jump to line 76 to disable fast log
`:404` jump to line 404 to disable stats log
`:557` jump to line 557 to configure logging outputs
`:580` jump to line 580 to configure interfaces
`:582` jump to line 582 to uncomment threads line and set to "4"
`:584` jump to 584 to select two digit cluster ID (optional)

*line numbers change version to version*

Suricata parses config and references last mention of a setting towards the end (overrides) if `Include other configs` is uncommented towards the end of the file it will reference external files for configuration as well

## rules
`/etc/suricata/rules/` location of rules files

`alert` vs `block` in rules depending on if block is desired in IPS mode.

## enable af_packet
`sudo vi /etc/sysconfig/suricata`
edit to the following
```
# The following parameters are the most commonly needed to configure
# suricata. A full list can be seen by running /sbin/suricata --help
# -i <network interface device>
# --user <acct name>
# --group <group name>

# Add options to be passed to the daemon
OPTIONS="--af-packet=enp5s0 --user suricata "
```
## update rules
`sudo suricata-update add-source local-emerging-threats http://192.168.2.20/share/emerging.rules.tar`

## set folder permissions
`sudo chown -R suricata:suricata /data/suricata`

## start service
`sudo systemctl start suricata`
`sudo systemctl status suricata`
`sudo systemctl enable suricata`
