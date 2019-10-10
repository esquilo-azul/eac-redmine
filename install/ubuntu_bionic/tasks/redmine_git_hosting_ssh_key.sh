#!/bin/bash

set -u
set -e

redmine_user=$("$INSTALL_ROOT2/lib/rails/user.sh")
ssh_key=$("$INSTALL_ROOT2/lib/redmine_git_hosting/ssh_key.sh")

function task_condition {
  return $("$INSTALL_ROOT2/lib/linux/sudo_file_exists.sh" "$redmine_user" "$ssh_key")
}
export -f task_condition

function task_fix {
  sudo -u "$redmine_user" -H ssh-keygen -t rsa -f "$ssh_key" -N ''
}
export -f task_fix
