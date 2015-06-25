#!/bin/bash

set -u
set -e

function task_condition {
	"$REDMINE_ROOT/bin/bundle" exec rake db:migrate:status 2> /dev/null | grep '^\s*down\s' > /dev/null 2> /dev/null
	if [ $? -eq 0 ]; then
		return 1
	fi	
}
export -f task_condition

#

function task_dependencies {
	echo redmine_bundle redmine_database_configuration redmine_secret_key_base redmine_database
}
export -f task_dependencies

function task_execute {
	"$REDMINE_ROOT/bin/bundle" exec rake trf1_sjap:fix_redmine_git_hosting_migrations
	"$REDMINE_ROOT/bin/bundle" exec rake db:migrate
	"$REDMINE_ROOT/bin/bundle" exec rake redmine:plugins:migrate
}
export -f task_execute