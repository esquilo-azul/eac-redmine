#!/bin/bash

set -u
set -e

PYTHON2_PACKAGE='python-minimal'

function task_condition {
  programeiro /apt/installed "$PYTHON2_PACKAGE"
}
export -f task_condition

function task_fix {
  programeiro /apt/assert_installed "$PYTHON2_PACKAGE"
}
