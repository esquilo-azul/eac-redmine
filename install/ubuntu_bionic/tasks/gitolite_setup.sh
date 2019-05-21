#!/bin/bash

set -u
set -e

function task_dependencies {
  echo gitolite_user_home gitolite redmine_git_hosting_ssh_key
}
export -f task_dependencies

function task_condition {
  sudo -u "$("$INSTALL_ROOT2/lib/rails/user.sh")" ssh -oBatchMode=yes -oStrictHostKeyChecking=no -i "$($INSTALL_ROOT2/lib/redmine_git_hosting/ssh_key.sh)" -l "$gitolite_user" localhost info
}
export -f task_condition

function task_execute {
  set -u
  set -e
  "$INSTALL_ROOT2/lib/apt/assert_installed.sh" openssh-server
  sudo service ssh restart
  local tempdir=$(sudo -u "$("$INSTALL_ROOT2/lib/rails/user.sh")" mktemp -d)
  local publickey_temp="$tempdir/$(basename "$("$INSTALL_ROOT2/lib/redmine_git_hosting/ssh_key.sh")")".pub
  sudo -u "$("$INSTALL_ROOT2/lib/rails/user.sh")" chmod 777 "$tempdir" -R
  sudo -u "$("$INSTALL_ROOT2/lib/rails/user.sh")" cp "$("$INSTALL_ROOT2/lib/redmine_git_hosting/ssh_key.sh")".pub "$publickey_temp"
  sudo -u "$gitolite_user" -H gitolite setup --pubkey "$publickey_temp"
  sudo -u "$("$INSTALL_ROOT2/lib/rails/user.sh")" rm -rf "$tempdir"
}
export -f task_execute
