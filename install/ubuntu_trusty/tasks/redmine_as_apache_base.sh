#!/bin/bash

set -u
set -e

function task_dependencies {
  echo development passenger_apache_configuration
}
export -f task_dependencies
