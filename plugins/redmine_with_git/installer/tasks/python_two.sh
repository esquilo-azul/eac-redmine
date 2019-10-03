#!/bin/bash

set -u
set -e

export PYTHON2_PACKAGE='python-minimal'

function task_condition {
  return $(programeiro /apt/installed "$PYTHON2_PACKAGE")
}

function task_fix {
  programeiro /apt/assert_installed "$PYTHON2_PACKAGE"
}
