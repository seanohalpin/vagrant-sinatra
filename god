#!/bin/bash
PATH=/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
. /etc/profile.d/rbenv-vars.sh
god -c /vagrant/sinatra.god -l /vagrant/log/god.log $@
