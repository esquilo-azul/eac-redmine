#!/bin/bash

set -u
set -e

function task_condition {
  return $("$INSTALL_ROOT/lib/apt/installed.sh" ruby)
}
export -f task_condition

function task_execute {
  sudo apt-get install -y ruby
}
export -f task_execute
