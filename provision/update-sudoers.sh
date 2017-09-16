#!/bin/bash
#
# Enable passthrough of http(s)_proxy and ftp_proxy
#
# See https://stackoverflow.com/questions/323957/how-do-i-edit-etc-sudoers-from-a-script
# echo "ARGS: " $@
if [ -z "$1" ]; then
  # When you run the script, you will run this block since $1 is empty.

  # We set this script as the `EDITOR` and then start `visudo` which
  # will now start and use THIS SCRIPT as its editor
  export EDITOR=$0 && sudo -E visudo
else
  # Under 16.04 (xenial) first arg is "--"
  if [ "$1" = "--" ]; then
    shift
  fi
  # When visudo starts this script, it will provide the name of the sudoers
  # file as the first parameter and $1 will be non-empty. Because of that,
  # visudo will run this block.

  echo "Updating sudoers"

  # We change the sudoers file and then exit

  # Delete the existing env_keep line (if any - none in Ubuntu 16.04 default install)
  sed -i '/Defaults\s\+env_keep.*/d' "$1"
  # Append our env_keep line /after/ the env_reset line
  sed -i '/Defaults\s\+env_reset/ a Defaults\tenv_keep = "http_proxy https_proxy ftp_proxy"' "$1"

  # echo "-----"
  # cat -n "$1"
  # echo "-----"
fi
