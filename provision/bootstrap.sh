#!/bin/bash
# * Install prerequisites for installing packages
# ** update package metadata
apt-get update
# ** ruby
apt-get install -y build-essential linux-headers-generic libssl-dev libreadline-dev zlib1g-dev
