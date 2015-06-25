#!/bin/bash

set -u
set -e

function task_dependencies {
	echo bundler redmine_database_configuration
}
export -f task_dependencies

function task_condition {
	$REDMINE_ROOT/bin/bundle check
}
export -f task_condition

function task_execute {
set +e
	"$REDMINE_ROOT/bin/bundle" install || "$REDMINE_ROOT/bin/bundle" update
	set -e
}
export -f task_execute


