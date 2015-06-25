#!/bin/bash

set -u
set -e

function task_condition {
	PGPASSWORD="$postgresql_password" psql -h 'localhost' -U "$postgresql_user" -c 'select 1' "$postgresql_database" > /dev/null 2> /dev/null
	return $? 
}
export -f task_condition

function task_dependencies {
	echo postgresql_user
}
export -f task_dependencies

function task_execute {
	"$REDMINE_ROOT/bin/bundle" exec rake db:setup	
}
export -f task_execute