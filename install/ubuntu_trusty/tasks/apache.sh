#!/bin/bash

set -u
set -e

function task_condition {
  return $("$INSTALL_ROOT/lib/apt/installed.sh" apache2)
}
export -f task_condition

function task_execute {
  sudo apt-get install -y apache2
}
export -f task_execute
