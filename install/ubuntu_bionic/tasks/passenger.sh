#!/bin/bash

set -u
set -e

function task_dependencies {
  echo ruby
}
export -f task_dependencies

function task_condition {
  return $("$INSTALL_ROOT2/lib/ruby/gem_installed.sh" passenger)
}
export -f task_condition

function task_execute {
  gem install -V --conservative passenger
}
export -f task_execute
