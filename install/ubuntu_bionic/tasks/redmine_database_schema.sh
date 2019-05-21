#!/bin/bash

set -u
set -e

function task_condition {
  return $("$INSTALL_ROOT2/lib/redmine/migration_status.sh")
}
export -f task_condition

#

function task_dependencies {
  echo redmine_bundle redmine_database_configuration redmine_secret_key_base redmine_database
}
export -f task_dependencies

function task_execute {
  "$INSTALL_ROOT2/lib/rails/rake.sh" redmine:migrate
}
export -f task_execute
