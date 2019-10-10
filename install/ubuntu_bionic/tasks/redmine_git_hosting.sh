#!/bin/bash

set -u
set -e

function task_condition {
  return 0
}

function task_dependencies {
  echo redmine_database gitolite gitolite_user_home redmine_git_hosting_ssh_key gitolite_setup \
    redmine_gitolite_sudoer redmine_git_hosting_settings gitolite_rc apt_ruby python_two
}
