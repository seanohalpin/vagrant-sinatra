#!/bin/bash
# * Install prerequisites for installing packages
# ** update package metadata
# apt-get update
# ** install required packages
# *** rvm
apt-get install -y systemd
# rbenv
apt-get install -y git
# ruby
apt-get install -y libssl-dev libreadline-dev zlib1g-dev
