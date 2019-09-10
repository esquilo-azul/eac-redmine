#!/bin/bash

set -u
set -e

REDMINE_WITH_GIT_PACKAGES=(build-essential libcurl4-openssl-dev libssh2-1 libssh2-1-dev cmake \
  libgpg-error-dev)

function task_condition {
  return $(programeiro /apt/installed "${REDMINE_WITH_GIT_PACKAGES[@]}")
}

function task_fix {
  programeiro /apt/assert_installed "${REDMINE_WITH_GIT_PACKAGES[@]}"
}
