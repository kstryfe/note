## File Scanning Framework (FSF) (soon to be replaced by strelka due to legacy dependency issues (python2))
`sudo yum install fsf`
`sudo vi /opt/fsf/fsf-server/conf/conf.py`

### server
"LOG_PATH" needs to be updated to "/data/fsf"
"YARA_PATH" needs to be updated to "/var/lib/yara-rules/rules.yara"
"EXPORT_PATH" needs to be updated to "/data/fsf/archive" (create subfolder)
"TIMEOUT" how long FSF will attempt to analyze a file before giving up and producing what it has at that point
"MAX_DEPTH" how many levels into a compressed file or folder FSF will recurse into for analysis
"ACTIVE_LOGGING_MODULES" needs to be set to "rockout"
example
```
#!/usr/bin/env python
#
# Basic configuration attributes for scanner. Used as default
# unless the user overrides them.
#

import socket

SCANNER_CONFIG = { 'LOG_PATH' : '/data/fsf',
                   'YARA_PATH' : '/var/lib/yara-rules/rules.yara',
                   'PID_PATH' : '/run/fsf/fsf.pid',
                   'EXPORT_PATH' : '/data/fsf/archive',
                   'TIMEOUT' : 60,
                   'MAX_DEPTH' : 10,
                   'ACTIVE_LOGGING_MODULES' : ['rockout'],
                   }

SERVER_CONFIG = { 'IP_ADDRESS' : "localhost",
                  'PORT' : 5800 }
```
#### client
example
`sudo vi /opt/fsf/fsf-client/conf/conf.py`
```
#!/usr/bin/env python
#
# Basic configuration attributes for scanner client.
#

# 'IP Address' is a list. It can contain one element, or more.
# If you put multiple FSF servers in, the one your client chooses will
# be done at random. A rudimentary way to distribute tasks.
SERVER_CONFIG = { 'IP_ADDRESS' : ['127.0.0.1',],
                  'PORT' : 5800 }

# Full path to debug file if run with --suppress-report
CLIENT_CONFIG = { 'LOG_FILE' : '{{ fsf_client_logfile }}' }
```
### create subfolders and set permissions
`sudo mkdir -p /data/fsf/{archive,logs}`
`sudo chown -R fsf:fsf /data/fsf`

## firewall rules
`sudo firewall-cmd --add-port 5800/tcp --permanent`
`sudo firewall-cmd --reload`

## start
`sudo systemctl start fsf`
`sudo systemctl status fsf`

## manual fsf test
`/opt/fsf/fsf-client/fsf-client.py --full <examplefile>` outputs hashes and other information in JSON format

## verify zeek functionality with fsf
`ls /data/zeek/extract_files/`
`tail /data/fsf/rockout.log`
