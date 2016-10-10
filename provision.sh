#!/usr/bin/env bash

function common(){
  apt-get update
  apt-get -y install collectd wget
}

function server(){
  cat << EOT >> /etc/collectd/collectd.conf.d/network.conf
LoadPlugin network

<Plugin network>
  <Listen "0.0.0.0" "25826">
    # SecurityLevel Sign
    # AuthFile "/etc/collectd/passwd"
    # Interface "eth0"
  </Listen>
</Plugin>
EOT
  service collectd restart
  wget https://github.com/facette/facette/releases/download/0.3.0/facette_0.3.0-1.trusty_amd64.deb
  dpkg -i facette_0.3.0-1.trusty_amd64.deb
  cat << EOT >> /etc/facette/providers/collectd.json
{
  "connector": {
    "type": "rrd",
    "path": "/var/lib/collectd/rrd",
    "pattern": "(?P<source>[^/]+)/(?P<metric>.+)/(?P<metric>.+).rrd"
  }
}
EOT
  service facette restart
}

function client(){
  cat << EOT >> /etc/collectd/collectd.conf.d/network.conf
LoadPlugin network

<Plugin network>
  <Server "192.168.33.10" "25826">
    # SecurityLevel Encrypt
    # Username "user"
    # Password "secret"
    # Interface "eth0"
  </Server>
</Plugin>
EOT
  service collectd restart
}

case $1 in
  server)
    common
    server
    ;;
  client)
    common
    client
    ;;
esac
