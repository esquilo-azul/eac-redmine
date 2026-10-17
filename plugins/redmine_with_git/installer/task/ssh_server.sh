#!/bin/bash

set -u
set -e

PACKAGES=("$SSH_SERVER_PACKAGE")

function task_condition {
  package_installed apt "${PACKAGES[@]}"
}

function task_fix {
  package_assert apt "${PACKAGES[@]}"
}
