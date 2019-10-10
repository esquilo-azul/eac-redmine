#!/bin/bash

set -u
set -e

GITOLITE_PACKAGE=gitolite3

function task_condition {
  return $("$INSTALL_ROOT2/lib/apt/installed.sh" "$GITOLITE_PACKAGE")
}
export -f task_condition

function task_execute {
  programeiro /apt/assert_installed "$GITOLITE_PACKAGE"
}
export -f task_execute
