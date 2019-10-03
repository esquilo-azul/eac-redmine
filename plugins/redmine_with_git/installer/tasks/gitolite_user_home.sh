#!/bin/bash

set -u
set -e

function task_dependencies {
  echo gitolite_user
}

function task_condition {
  local current_home=$(eval echo ~$gitolite_user)
  if [ "$current_home" != "$gitolite_user_home" ]; then
    return 1
  fi
  if [ ! -d "$gitolite_user_home" ]; then
    return 1
  fi
}

function task_fix {
  sudo usermod -d "$gitolite_user_home" "$gitolite_user"
  sudo mkdir -p "$gitolite_user_home"
  sudo chown "$gitolite_user:$gitolite_user" "$gitolite_user_home"
}
