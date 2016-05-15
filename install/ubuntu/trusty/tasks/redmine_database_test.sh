#!/bin/bash

set -u
set -e

function task_condition {
	PGPASSWORD="$postgresql_password" psql -h 'localhost' -U "$postgresql_user" -c 'select 1' "$postgresql_database_test" > /dev/null 2> /dev/null
	return $? 
}
export -f task_condition

function task_dependencies {
	echo postgresql_user_superuser
}
export -f task_dependencies

function task_execute {
	sudo -u postgres createdb -O "$postgresql_user" "$postgresql_database_test"
}
export -f task_execute