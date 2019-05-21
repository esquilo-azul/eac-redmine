#!/bin/bash

set -u
set -e


function passenger_load {
  echo LoadModule passenger_module "$("$INSTALL_ROOT2/lib/passenger/apache_library.sh")"
}

function passenger_conf {
  echo "
  <IfModule mod_passenger.c>
       PassengerRoot $("$INSTALL_ROOT2/lib/passenger/root.sh")
       PassengerDefaultRuby $("$INSTALL_ROOT2/lib/ruby/path.sh")
  </IfModule>"
}

function task_dependencies {
  echo passenger_apache_library apache
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
  if [ "$(passenger_load | "$INSTALL_ROOT2/lib/text/diff-stdin-file.sh" /etc/apache2/mods-enabled/passenger.load )" -ne 0 ]; then
    return 1
  fi
  if [ "$(passenger_conf | "$INSTALL_ROOT2/lib/text/diff-stdin-file.sh" /etc/apache2/mods-enabled/passenger.conf )" -ne 0 ]; then
    return 1
  fi
}
export -f task_condition

function task_execute {
  passenger_load | sudo tee /etc/apache2/mods-available/passenger.load > /dev/null
  passenger_conf | sudo tee /etc/apache2/mods-available/passenger.conf > /dev/null
  sudo a2enmod passenger
}
export -f task_execute

function task_triggers {
  echo apache_restart
}
export f task_triggers
