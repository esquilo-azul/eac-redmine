#!/bin/bash

set -u
set -e

function task_dependencies {
  echo redmine_database gitolite gitolite_user_home redmine_git_hosting_ssh_key gitolite_setup redmine_gitolite_sudoer redmine_git_hosting_settings gitolite_rc apt_ruby
}
export -f task_dependencies
