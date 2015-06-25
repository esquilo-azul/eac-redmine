#!/bin/bash

set -u
set -e


function task_dependencies {
	echo passenger_apache_library
}
export -f task_dependencies

function task_condition {
	if [ ! -f /etc/apache2/mods-available/passenger.load ]; then
		return 1
	fi
	if [ ! -f /etc/apache2/mods-available/passenger.conf ]; then
		return 1
	fi
	if [ ! -f /etc/apache2/mods-enabled/passenger.load ]; then
		return 1
	fi
	if [ ! -f /etc/apache2/mods-enabled/passenger.conf ]; then
		return 1
	fi
}
export -f task_condition

function task_execute {
	echo LoadModule passenger_module "$("$INSTALL_ROOT/lib/passenger/apache_library.sh")" | sudo tee /etc/apache2/mods-available/passenger.load > /dev/null
	echo "
	<IfModule mod_passenger.c>
	     PassengerRoot $("$INSTALL_ROOT/lib/passenger/apache_library.sh")
	     PassengerDefaultRuby $("$INSTALL_ROOT/lib/ruby/path")
	</IfModule>" | sudo tee /etc/apache2/mods-available/passenger.conf > /dev/null
	sudo a2enmod passenger
	sudo service apache2 restart
}
export -f task_execute
