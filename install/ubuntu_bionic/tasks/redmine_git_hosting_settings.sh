#!/bin/bash

set -u
set -e

function redmine_git_hosting_setting_template {
  export redmine_git_hosting_ssh_key=$("$INSTALL_ROOT2/lib/redmine_git_hosting/ssh_key.sh")
  programeiro /template/apply "$INSTALL_ROOT2/template/redmine_git_hosting_setting_value.sql"
}
export -f redmine_git_hosting_setting_template

function redmine_git_hosting_setting_current {
  programeiro /redmine/get_setting_value 'plugin_redmine_git_hosting'
}
export -f redmine_git_hosting_setting_current

function task_dependencies {
  echo redmine_database_schema
}

export -f task_dependencies

function task_condition {
  return $(programeiro /text/diff_commands 'redmine_git_hosting_setting_template' \
    'redmine_git_hosting_setting_current')
}
export -f task_condition

function task_fix {
  set -u
  set -e
  local setting_value=$(redmine_git_hosting_setting_template | programeiro /text/escape_single_quotes)
  programeiro /redmine/set_setting_value 'plugin_redmine_git_hosting' "$setting_value"
  programeiro /redmine/installer/triggers/set 'redmine_git_hosting_rescue'
}
