#!/bin/bash

set -u
set -e

export LINK_PATH="/var/www/html/${instance_id}"

function task_dependencies {
  echo apache
}
export -f task_dependencies

function task_condition {
  # Link não existe
  if [ ! -e "$LINK_PATH" ]; then
    return 1
  fi

  # Link aponta para local incorreto
  PUBLIC_DIR="$REDMINE_ROOT/public/"
  if [ -e "$LINK_PATH" -a "$(readlink "$LINK_PATH")" != "$PUBLIC_DIR" ]; then
    return 1
  fi
}
export -f task_condition

function task_execute {
  PUBLIC_DIR="$REDMINE_ROOT/public/"
  sudo rm -f "$LINK_PATH"
  sudo ln -s "$PUBLIC_DIR" "$LINK_PATH"
}
export -f task_execute
