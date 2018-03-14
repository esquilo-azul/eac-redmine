#!/bin/bash

set -u
set -e

function task_dependencies {
  echo apache
}
export -f task_dependencies

function task_condition {
  # Link não existe
  LINK=/var/www/html/redmine
  if [ ! -e "$LINK" ]; then
    return 1
  fi

  # Link aponta para local incorreto
  PUBLIC_DIR="$REDMINE_ROOT/public/"
  if [ -e "$LINK" -a $(readlink "$LINK") != "$PUBLIC_DIR" ]; then
    return 1
  fi
}
export -f task_condition

function task_execute {
  PUBLIC_DIR="$REDMINE_ROOT/public/"
  LINK=/var/www/html/redmine
  sudo rm -f "$LINK"
  sudo ln -s "$PUBLIC_DIR" "$LINK"
}
export -f task_execute
