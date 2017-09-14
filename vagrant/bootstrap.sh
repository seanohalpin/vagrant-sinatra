#!/bin/bash
# * Install prerequisites for installing packages
# ** update package metadata
apt-get update
# ** install required packages
# *** rvm
apt-get install -y gnupg2 systemd
