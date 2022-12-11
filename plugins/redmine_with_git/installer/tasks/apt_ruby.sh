#!/bin/bash

set -u
set -e

export RUBY_PACKAGE="ruby"

function task_condition {
  package_installed apt "$RUBY_PACKAGE"
}

function task_fix {
  package_assert apt "$RUBY_PACKAGE"
}
