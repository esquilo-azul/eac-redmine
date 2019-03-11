#!/bin/bash

set -u
set -e

function task_dependencies {
  echo passenger
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
  "$INSTALL_ROOT/lib/apt/assert_installed.sh" libcurl4-openssl-dev libssl-dev apache2-dev libapr1-dev libaprutil1-dev apache2
  passenger-install-apache2-module -a
}
export -f task_execute
