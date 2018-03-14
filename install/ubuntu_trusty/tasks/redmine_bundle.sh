#!/bin/bash

set -u
set -e

function task_dependencies {
  echo bundler redmine_database_configuration redmine_configuration
}
export -f task_dependencies

function task_condition {
  $REDMINE_ROOT/bin/bundle check
}
export -f task_condition

function task_execute {
  set +e
  # Dependências para o Redmine
  "$INSTALL_ROOT/lib/apt/assert_installed.sh" libmagickwand-dev libxslt1-dev libpq-dev imagemagick git
  # Dependências para o RedmineGitHosting
  "$INSTALL_ROOT/lib/apt/assert_installed.sh" build-essential libssh2-1 libssh2-1-dev cmake libgpg-error-dev
  "$REDMINE_ROOT/bin/bundle" install || "$REDMINE_ROOT/bin/bundle" update
  set -e
}
export -f task_execute

function task_triggers {
  echo apache_restart
}
export f task_triggers
