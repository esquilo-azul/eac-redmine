#!/bin/bash

set -u
set -e

function task_dependencies {
  echo gitolite_rc gitolite redmine_git_hosting_ssh_key
}

function task_condition {
  sudo -u "$(programeiro /rails/user)" ssh -oBatchMode=yes -oStrictHostKeyChecking=no -i "$(programeiro /redmine_git_hosting/ssh_key)" -l "$gitolite_user" localhost info
}

function task_fix {
  set -u
  set -e
  programeiro /apt/assert_installed openssh-server
  sudo service ssh restart
  local tempdir=$(sudo -u "$(programeiro /rails/user)" mktemp -d)
  local publickey_temp="$tempdir/$(basename "$(programeiro /redmine_git_hosting/ssh_key)")".pub
  sudo -u "$(programeiro /rails/user)" chmod 777 "$tempdir" -R
  sudo -u "$(programeiro /rails/user)" cp "$(programeiro /redmine_git_hosting/ssh_key)".pub "$publickey_temp"
  sudo -u "$gitolite_user" -H gitolite setup --pubkey "$publickey_temp"
  sudo -u "$(programeiro /rails/user)" rm -rf "$tempdir"
}
