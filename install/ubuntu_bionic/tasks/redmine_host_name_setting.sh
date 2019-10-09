#!/bin/bash

set -u
set -e

function host_name_setting_template {
  echo "${address_server}${address_path}"
}
export -f host_name_setting_template

function host_name_setting_current {
  programeiro /redmine/get_setting_value 'host_name'
}
export -f host_name_setting_current

function task_dependencies {
  echo redmine_database_schema
}

export -f task_dependencies

function task_condition {
  return $(programeiro /text/diff_commands 'host_name_setting_template' 'host_name_setting_current')
}
export -f task_condition

function task_execute {
  set -u
  set -e
  local setting_value=$(host_name_setting_template | "$INSTALL_ROOT2/lib/text/escape_single_quotes.sh")
  programeiro /redmine/set_setting_value 'host_name' "$setting_value"
}
export -f task_execute
