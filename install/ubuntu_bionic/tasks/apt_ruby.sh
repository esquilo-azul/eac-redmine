#!/bin/bash

set -u
set -e

function task_condition {
  return $("$INSTALL_ROOT2/lib/apt/installed.sh" ruby)
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT2/lib/apt/assert_installed.sh" ruby
}
export -f task_execute
