#!/bin/bash

set -u
set -e

function task_dependencies {
  echo redmine_bundle rugged_build_config
}

function task_condition {
  programeiro /rails/bundle exec ruby -e "require 'rugged'; exit(Rugged.features.include?(:ssh) ? 0 : 1)"
}

function task_fix {
  programeiro /rails/bundle pristine rugged
  programeiro /redmine/installer/triggers/set 'restart_application'
}
