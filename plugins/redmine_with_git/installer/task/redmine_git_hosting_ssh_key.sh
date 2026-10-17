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
  # https://github.com/libgit2/pygit2/issues/1013#issuecomment-679200156
  sudo -u "$redmine_user" -H ssh-keygen -m PEM -t ed25519 -b 2048 -f "$ssh_key" -N ''
}
export -f task_fix
