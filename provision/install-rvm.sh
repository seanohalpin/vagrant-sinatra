#!/bin/bash
# verify rvm public key
# gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL "https://rvm.io/mpapis.asc" | sudo gpg2 --import -
# RVM_URL=https://get.rvm.io
RVM_URL="https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer"
# Single user install
# \curl -sSL "$RVM_URL" | bash -s $1
# Multi-user install
curl -sSL "$RVM_URL" | sudo bash -s $1
