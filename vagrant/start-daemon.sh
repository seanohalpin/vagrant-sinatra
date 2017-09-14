#!/bin/sh
# Run as root
systemctl --system daemon-reload &&
  systemctl enable god.service &&
  systemctl start god.service
