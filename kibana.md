`sudo yum install kibana`
`sudo vi /etc/kibana/kibana.yml`

`:2` "server port"
`:7` "server.host" ip that server listens on.
`:13` "server.basepath" allows for specific file path to be specified to prevent conflicts with proxied applications
`:22` "server.maxPayloadBytes"
`:25` server.name
`:28` "elasticsearch.hosts"  specify elastic host(s) (comma separated entries in quotes) to talk to. (master or coordinating node in a cluster)

`:37` "kibanna.index" default index kibana stores settings, etc. in.
