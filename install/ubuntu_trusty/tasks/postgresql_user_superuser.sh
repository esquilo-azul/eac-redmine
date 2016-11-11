#!/bin/bash

set -u
set -e

function task_condition {
	value=$(PGPASSWORD="$postgresql_password" psql -h 'localhost' -U "$postgresql_user" -c "select usesuper from pg_user where usename='$postgresql_user'" -q -t template1 | tr -d '[[:space:]]')
  if [ "$value" == 't' ]; then
    return 0
  else
    return 1
  fi
}
export -f task_condition

function task_dependencies {
	echo postgresql_user
}
export -f task_dependencies

function task_execute {
	sudo -u postgres psql -c "ALTER ROLE $postgresql_user WITH SUPERUSER;"  > /dev/null
}
export -f task_execute
