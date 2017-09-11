#!/usr/bin/env bash
source $HOME/.rvm/scripts/rvm || source /etc/profile.d/rvm.sh
if [ -z "$https_proxy" ]; then
  rvm use --default --install $1
else
  rvm use --default --install $1 --proxy "$https_proxy"
fi
shift
if (( $# ))
then gem install $@
fi
rvm cleanup all
