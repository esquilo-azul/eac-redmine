#!/bin/bash

set -u
set -e

redmine_user=$(programeiro /rails/user)
ssh_key=$(programeiro /redmine_git_hosting/ssh_key)

function task_condition {
  return $(programeiro /linux/sudo_file_exists "$redmine_user" "$ssh_key")
}
export -f task_condition

function task_fix {
  sudo -u "$redmine_user" -H ssh-keygen -t rsa -f "$ssh_key" -N ''
}
export -f task_fix
