#!/bin/bash

set -u
set -e

GITOLITE_PACKAGE=gitolite3

function task_condition {
  return $("$INSTALL_ROOT/lib/apt/installed.sh" "$GITOLITE_PACKAGE")
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT/lib/apt/assert_installed.sh" "$GITOLITE_PACKAGE"
}
export -f task_execute
