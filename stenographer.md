`sudo yum install stenographer`
`sudo vi /etc/stenographer/config`
verify it looks like the following (for lab, normally you bind to a management NIC address)
```
{
  "Threads": [
    { "PacketsDirectory": "/data/stenographer/packets"
    , "IndexDirectory": "/data/stenographer/index"
    , "MaxDirectoryFiles": 30000
    , "DiskFreePercentage": 10
    }
  ]
  , "StenotypePath": "/usr/bin/stenotype"
  , "Interface": "enp5s0"
  , "Port": 1234
  , "Host": "127.0.0.1"
  , "Flags": []
  , "CertPath": "/etc/stenographer/certs"
}
```

## generate stenographer keys
`sudo /usr/bin/stenokeys.sh stenographer stenographer`
exports keys to `/etc/stenographer/certs`
syntax `stenokeys.sh <user> <group>`

# populate directory tree
`cd /data/stenographer`
`sudo mkdir {index,packets}`
`sudo chown -R stenographer:stenographer /data/stenographer`


## notes
- "DiskFreePercentage" dictates the point at which stenographer will start overwriting old data, i.e. at 10% free (90% full). A buffer of free space is reccomended to account for disk latency to prevent filling drive and crashing stenographer on spinning disks.
- "Host" specifies visible address for remote inbound connections. "0.0.0.0" is wildcard open, but otherwise a specific reachable interface IP
