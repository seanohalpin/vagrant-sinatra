#!/bin/sh
sudo cp /vagrant/systemd/system/god.service /etc/systemd/system/god.service
sudo /vagrant/vagrant/start-daemon.sh
