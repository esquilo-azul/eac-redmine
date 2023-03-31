#!/bin/bash

set -u
set -e

REDMINE_WITH_GIT_PACKAGES=(build-essential libcurl4-openssl-dev libssh2-1 libssh2-1-dev cmake \
  libgpg-error-dev libssl-dev)

function task_condition {
  package_installed apt "${REDMINE_WITH_GIT_PACKAGES[@]}"
}

function task_fix {
  package_assert apt "${REDMINE_WITH_GIT_PACKAGES[@]}"
}
