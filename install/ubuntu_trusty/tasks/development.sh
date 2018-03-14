#!/bin/bash

set -u
set -e

function task_dependencies {
  echo redmine_database_schema redmine_database_test redmine_git_hosting \
    redmine_enabled_scm_setting redmine_host_name_setting expect
}
export -f task_dependencies
