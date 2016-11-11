#!/bin/bash

set -u
set -e

function task_condition {
	return $("$INSTALL_ROOT/lib/redmine/migration_status.sh")
}
export -f task_condition

#

function task_dependencies {
	echo redmine_bundle redmine_database_configuration redmine_secret_key_base redmine_database
}
export -f task_dependencies

function task_execute {
	"$REDMINE_ROOT/bin/bundle" exec rake db:migrate redmine_git_hosting:migration_tools:fix_migration_numbers redmine:plugins:migrate
}
export -f task_execute