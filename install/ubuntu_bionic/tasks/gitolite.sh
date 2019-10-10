#!/bin/bash

set -u
set -e

GITOLITE_PACKAGE=gitolite3

function task_condition {
  programeiro /apt/installed "$GITOLITE_PACKAGE"
}

function task_fix {
  programeiro /apt/assert_installed "$GITOLITE_PACKAGE"
}
