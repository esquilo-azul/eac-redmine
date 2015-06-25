#!/bin/bash

set -u
set -e

function task_dependencies {
	echo passenger passenger_apt_dependencies
}
export -f task_dependencies

function task_condition {
	if [ -f "$("$INSTALL_ROOT/lib/passenger/apache_library.sh")" ]; then
		return 0
	else
		return 1
	fi
}
export -f task_condition

function task_execute {
	passenger-install-apache2-module -a
}
export -f task_execute


