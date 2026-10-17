#!/bin/bash

set -u
set -e

function task_condition {
  return 0
}

function task_dependencies {
  echo gitolite_admin_base_hooks_clean gitolite_ruby_access gitolite_setup \
    redmine_gitolite_sudoer redmine_git_hosting_settings rugged_ssh_support \
    gitolite_hooks_ruby
}
