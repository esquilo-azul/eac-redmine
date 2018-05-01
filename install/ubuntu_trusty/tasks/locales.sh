#!/bin/bash

set -u
set -e

function task_condition {
  if [ -n "$("$INSTALL_ROOT/lib/linux/locale/missing.sh")" ]; then
    return 1
  fi
}
export -f task_condition

function task_execute {
  IFS=$'\n' sudo locale-gen "$("$INSTALL_ROOT/lib/linux/locale/missing.sh")"
}
export -f task_execute
