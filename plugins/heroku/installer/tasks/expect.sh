#!/bin/bash

set -u
set -e

export EXPECT_PACKAGE='expect'

function task_condition {
  return $(programeiro /apt/installed "$EXPECT_PACKAGE")
}

function task_fix {
  programeiro /apt/assert_installed "$EXPECT_PACKAGE"
}
