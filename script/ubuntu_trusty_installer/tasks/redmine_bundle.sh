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
	"$INSTALL_ROOT/lib/apt/assert_installed.sh" libmagickwand-dev libxslt1-dev libpq-dev imagemagick
	"$REDMINE_ROOT/bin/bundle" install || "$REDMINE_ROOT/bin/bundle" update
	set -e
}
export -f task_execute


