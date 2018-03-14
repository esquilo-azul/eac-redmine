#!/bin/bash

set -u
set -e

function task_dependencies {
  echo ruby
}
export -f task_dependencies

function task_condition {
  return $("$INSTALL_ROOT/lib/ruby/gem_installed.sh" bundler)
}
export -f task_condition

function task_execute {
  gem install -V --conservative bundler
}
export -f task_execute
