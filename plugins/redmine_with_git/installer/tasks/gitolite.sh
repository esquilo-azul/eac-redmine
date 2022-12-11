#!/bin/bash

set -u
set -e

export GITOLITE_PACKAGE='gitolite3'

function task_condition {
  package_installed apt "$GITOLITE_PACKAGE"
}

function task_fix {
  package_assert apt "$GITOLITE_PACKAGE"
}
