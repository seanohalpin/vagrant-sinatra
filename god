#!/bin/bash
. /home/vagrant/.rvm/scripts/rvm
cd /vagrant
/home/vagrant/.rvm/gems/ruby-2.4.1/bin/god -c sinatra.god -l /vagrant/log/god.log $@
