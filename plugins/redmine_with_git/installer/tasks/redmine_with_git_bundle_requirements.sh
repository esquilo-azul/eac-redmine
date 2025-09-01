#!/bin/bash

set -u
set -e

function greater_or_equal_noble() {
  dpkg --compare-versions "$(programeiro /ubuntu/version)" ge '24.04'
}

REDMINE_WITH_GIT_PACKAGES=(build-essential libcurl4-openssl-dev libssh2-1-dev cmake \
  libgpg-error-dev libssl-dev)

if greater_or_equal_noble ; then
  REDMINE_WITH_GIT_PACKAGES+=(libssh2-1t64)
else
  REDMINE_WITH_GIT_PACKAGES+=(libssh2-1)
fi

function task_condition {
  package_installed apt "${REDMINE_WITH_GIT_PACKAGES[@]}"
}

function task_fix {
  package_assert apt "${REDMINE_WITH_GIT_PACKAGES[@]}"
}
