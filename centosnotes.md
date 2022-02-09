# Centos notes

UTC timezone with default ntp pool

minimal install

- disable kdump

network config (enough to get ssh in)
- int eno1 management
- int enp5s0 collector


## Data partition
collector storage
- /data/zeek, /data/suricata, etc.
deconflict disk IO between tools, each to separate disk/partition/VG/LV
separate VG/partitions/disks

## OS
- /var/log
mirrored VG / RAID


## partition scheme
boilerplate
- /
- /boot
- /boot/efi
- swap


*all partitions besides /boot and /boot/efi resized to 1G for staging*
## System
- add /tmp
- add /var
- add /var/log
- add /var/log/audit
## Data
- add /data/stenographer
- add /data/suricata
- add /data/zeek
- add /data/elasticsearch
- add /data/fsf
- add /data/kafka


## Volume Groups
assign created partitions to specific volume groups by modifying setting in anaconda partition form

- create VG per disk (System (500G), Data(1T))
- assign OS level partitions OS disk (500G)
- assign data partitions to Data VG (1T)


## Partition sizing
*leave capacity field blank to autofill max available capacity, always do those last*
## System / 255.56G (leave field blank)
- /boot 1G (default)
- /boot/efi 200M (default)
- swap 16G (half of RAM)
- /tmp 5G
- /var 50G
- /var/log 50G
- /var/log/audit 50G
### Data
- /data/stenographer 500G
- /data/suricata 25G
- /data/zeek 25G
- /data/elasticsearch 271.5G (leave field blank)
- /data/fsf 10G
- /data/kafka 100G


### manual configuration file editing

/etc/sysconfig/network-scripts

`sudo vi /etc/sysconfig/network-scripts/ifcfg-eno1`
- set all boolean IPv6 values to "no"

`sudo vi /etc/sysctl.config`
- append
```
net.ipv6.all disable_ipv6 = 1
net.ipv6.conf.default disable_ipv6 = 1
```

`sudo sysctl -p`

`sudo yum install <package>`
`scp student@192.168.2.20:/repos/configs/local.repo /home/admin'

`/etc/yum.repo.d/`
`sudo rm -rf rm /etc/yum.repo.d/CentOS-*`

`/etc/yum.repo.d/`
`sudo mv /home/admin/local.repo /etc/yum.repo.d/`
`sudo yum clean all`
`sudo yum makecache fast`
`sudo yum update`
`sudo yum upgrade`
`sudo yum install`
`sudo yum provides <utility name>`
`sudo yum search`

## systemd
`sudo systemctl status sshd`
`sudo systemctl <start/stop/restart/enable/disable> sshd`
`sudo systemctl list-unit-files`

`sudo vi /usr/lib/systemd/system/sshd.service`

### within unit files
**load order control**
- before (start before specified service)
- after (start after specified service)
- wants (optional dependency)
- requires (mandatory dependency)


## SELinux
`ll -Z` display SELinux context for files/directories
`sestatus` display SELinux status
`sudo vi /etc/selinux/config` reboot required to apply changes
`sudo tail /var/log/audit/audit.log` log location
`res=success` log entry that displays if SELinux blocks an action or not
`audit2why`tool to simplify parsing audit logs provided by policycoreutils package *supposedly*
`grep success /var/log/audit/audit.log | audit2why` example syntax to use audit2why
`chcon` change context
`restorecon` restore context to default
`touch ./autorelabel` NUKE Option do not use

### contexts
`unconfined_u` user context
`object_r` role contexts
`user_home_t` type
`:s0-s0:c0.c1023` Multi-layer security (MLS) (uncommon in most implementations)


## random
`cd` without any trailing entries returns to home directory
`sudo -s` elevate privileges to root while maintaining log audit entries as your user.
`sudo systemctl status <unit-file>` also gives location of configuration file location
`!!` repeat last typed command `sudo !!` to repeat last command with elevated rights
`^vi^tail` find and replace text in previous command, in example run tail on a file previously opened in vi
`mkdir {subfolder1,subfolder2}` create multiple directories in current folder with a single command.
## VI commands
`:set nu` display line numbers
`:<linenumber>` jump to line number
