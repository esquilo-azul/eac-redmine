#!/bin/bash

set -u
set -e

PACKAGES=("$SSH_SERVER_PACKAGE")

function task_condition {
  programeiro /apt/installed "${PACKAGES[@]}"
}

function task_fix {
  programeiro /apt/assert_installed "${PACKAGES[@]}"
}
