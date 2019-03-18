#!/bin/bash

set -u
set -e

PYTHON2_PACKAGE='python-minimal'

function task_condition {
  return $("$INSTALL_ROOT/lib/apt/installed.sh" "$PYTHON2_PACKAGE")
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT/lib/apt/assert_installed.sh" "$PYTHON2_PACKAGE"
}
export -f task_execute
