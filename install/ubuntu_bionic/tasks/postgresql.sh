#!/bin/bash

set -u
set -e

export POSTGRESQL_PACKAGE="postgresql-${postgresql_version}"

function task_condition {
  return $("$INSTALL_ROOT/lib/apt/installed.sh" "$POSTGRESQL_PACKAGE")
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT/lib/apt/assert_installed.sh" "$POSTGRESQL_PACKAGE"
}
export -f task_execute
