#!/bin/bash

set -u
set -e

export RUBY_PACKAGE="ruby"

function task_condition {
  programeiro /apt/installed "$RUBY_PACKAGE"
}

function task_fix {
  programeiro /apt/assert_installed "$RUBY_PACKAGE"
}
