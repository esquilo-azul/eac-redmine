#!/bin/bash

set -u
set -e

function task_condition {
  if id -u "$gitolite_user" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}
export -f task_condition

function task_fix {
  sudo useradd --system "$gitolite_user"
}
