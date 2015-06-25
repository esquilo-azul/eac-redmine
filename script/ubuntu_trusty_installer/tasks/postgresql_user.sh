#!/bin/bash

set -u
set -e

function task_condition {
	echo PGPASSWORD="$postgresql_password" psql -h 'localhost' -U "$postgresql_user" -c 'select 1' template1 > /dev/null 2> /dev/null	
	return $?
}
export -f task_condition

function task_dependencies {
	echo postgresql
}
export -f task_dependencies

function task_execute {
	sudo -u postgres psql -c "CREATE ROLE $postgresql_user LOGIN ENCRYPTED PASSWORD '$postgresql_password' NOINHERIT VALID UNTIL 'infinity';" > /dev/null
}
export -f task_execute