#!/bin/bash

set -u
set -e

GITOLITE_PACKAGE=gitolite3

function task_condition {
  programeiro /apt/installed "$GITOLITE_PACKAGE"
}
export -f task_condition

function task_execute {
  programeiro /apt/assert_installed "$GITOLITE_PACKAGE"
}
export -f task_execute
