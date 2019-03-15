#!/bin/bash

set -u
set -e

function task_condition {
  return $("$INSTALL_ROOT/lib/apt/installed.sh" gitolite)
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT/lib/apt/assert_installed.sh" gitolite
}
export -f task_execute
