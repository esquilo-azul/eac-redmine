#!/bin/bash

set -u
set -e

function task_condition {
  if [ ! -f "/etc/postgresql/${postgresql_version}/main/postgresql.conf" ]; then
    return 1
  fi
}
export -f task_condition

function task_dependencies {
  echo postgresql
}
export -f task_dependencies

function task_execute {
  sudo pg_createcluster "${postgresql_version}" main --start
}
export -f task_execute
