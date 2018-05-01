#!/bin/bash

set -u
set -e

function task_condition {
  return $("$INSTALL_ROOT/lib/linux/service_running.sh" postgresql)
}
export -f task_condition

function task_dependencies {
  echo postgresql_cluster
}
export -f task_dependencies

function task_execute {
  sudo service postgresql status
  sudo service postgresql start
  sudo service postgresql status
}
export -f task_execute
