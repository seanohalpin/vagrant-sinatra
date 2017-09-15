#!/bin/sh
sudo cp /vagrant/systemd/system/god.service /etc/systemd/system/god.service
sudo /vagrant/provision/start-daemon.sh
