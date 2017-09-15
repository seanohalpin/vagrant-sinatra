#!/bin/bash
. /etc/profile.d/rbenv-vars.sh
cd /vagrant
exec god $@
