#!/bin/bash

set -u
set -e

PACKAGE_ARGS=('systemctl' "$SSH_SERVER_SERVICE")

function task_condition {
  SUDO=t package_installed "${PACKAGE_ARGS[@]}"
}

function task_dependencies {
  echo ssh_server
}

function task_fix {
  SUDO=t package_assert "${PACKAGE_ARGS[@]}"
}
