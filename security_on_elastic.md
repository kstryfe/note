

`sudo vi /etc/elasticsearch/elasticsearch.yml`
- make note of "node.name" (node-1)
append
`xpack.security.enabled: true`

##generate CA
`cd /usr/share/elasticsearch`
`/usr/share/elasticsearch/bin/elasticsearch-certutil ca`

## generate x509 certs
`sudo /usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12 --name <node name> --ip <ip elastic is bound to>`
## move certs to store and configure elasticsearch to use them
`sudo mkdir /etc/elasticsearch/certs`

`sudo cp /usr/share/elasticsearch/node-1.p12 /etc/elasticsearch/certs/`
`sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch/certs`

`sudo vi /etc/elasticsearch/elasticsearch.yml`
append
```
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: full
xpack.security.transport.ssl.keystore.path: certs/node-1.p12
xpack.security.transport.ssl.truststore.path: certs/node-1.p12


```




`sudo /usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password`

`sudo /usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password`

``

`sudo vi /etc/elasticsearch/elasticsearch.yml`
append
```
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.keystore.path: certs/node-1.p12
xpack.security.http.ssl.truststore.path: certs/node-1.p12

```
`sudo /usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.http.ssl.keystore.secure_password`

`sudo /usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.http.ssl.truststore.secure_password`


`sudo /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive`

`curl -k -u elastic https://localhost:9200`
`curl -k -u elastic https://localhost:9200/_cat/nodes`


`/etc/kibana/kibana.yml`
`:46` username:password (leave default)
`:47` set elasticsearch password for Kibana
`:116` xpack.security.encryptionKey: "arandom32characterstringgoeshere"
`:117` xpack.security.sessionTimeout: 60000
`mkdir -p /etc/kibana/kibana.yml`
`sudo modir /etc/kibana/certs`
`cd /etc/kibana/certs/`
`ssudo openssl req -newkey rsa:2048 -nodes -keyout kibana.key -x509 -days 365 -out kibana.crt`

`:51` true
`:52` /etc/kibana/certs/kibana.crt
`:53` /etc/kibana/certs/kibana.key
`:28` change to https

convert CA to kibana compatible format and copy to cert store
`sudo openssl pkcs12 -in /usr/share/elasticsearch/elastic-stack-ca.p12 -clcerts -nokeys -chain -out /etc/kibana/certs/elastic-stack-ca.pem`

`:63` set to /etc/kibana/certs/elastic-stack-ca.pem`
`:66` change from full to certificate



## kibana roles and users

Read only (read,view_index_metadata) non admin (analyst)
## Logstash
`sudo vi /etc.logstash/conf.d/logstash-9999-output-elasticsearch.conf`

add to each section under "host"
```
ssl => true
cacert => '/etc/logstash/certs/elastic-stack-ca.pem'
user => logstash_writer
password => training
```

`sudo mkdir /etc/logstash/certs`
`sudo cp /etc/kibana/certs/elastic-stack-ca.pem /etc/logstash/certs/`
`sudo chown -R logstash:logstash /etc/logstash`
