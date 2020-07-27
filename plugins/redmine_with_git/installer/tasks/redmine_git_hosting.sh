#!/bin/bash

set -u
set -e

function task_condition {
  return 0
}

function task_dependencies {
  echo gitolite_setup redmine_gitolite_sudoer redmine_git_hosting_settings apt_ruby python_two
}
