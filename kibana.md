`sudo yum install kibana`
`sudo vi /etc/kibana/kibana.yml`

`:2` "server port"
`:7` "server.host" ip that server listens on.
`:13` "server.basepath" allows for specific file path to be specified to prevent conflicts with proxied applications
`:22` "server.maxPayloadBytes"
`:25` server.name
`:28` "elasticsearch.hosts"  specify elastic host(s) (comma separated entries in quotes) to talk to. (master or coordinating node in a cluster)

`:37` "kibanna.index" default index kibana stores settings, etc. in.


"Stack Management">"Index Management"

Indices starting with a "." are hidden, similar to linux filesystem file/folder names.

"Stack Management">"Index Patterns" and specify indices with

"related.id" session fingerprint (similar to netflow) that ties information about a connection together across multiple logs.


## Discover



## Visualizations
"fields within documents" create "visualizations" which make up "dashboards"

`cd ~`
`curl -L -O http://192.168.2.20/share/ecskibana.tar`
`tar -xvf ecskibana.tar`


## notes
kibana logs to /var/log/messages by default (not optimal)
