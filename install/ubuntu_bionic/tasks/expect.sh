#!/bin/bash

set -u
set -e

function task_condition {
  return $("$INSTALL_ROOT2/lib/apt/installed.sh" expect)
}
export -f task_condition

function task_execute {
  programeiro /apt/assert_installed expect
}
export -f task_execute
