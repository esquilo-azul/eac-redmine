#!/bin/bash

set -u
set -e

function redmine_git_hosting_setting_template {
  export redmine_git_hosting_ssh_key=$("$INSTALL_ROOT2/lib/redmine_git_hosting/ssh_key.sh")
  "$INSTALL_ROOT2/lib/text/template.sh" "$INSTALL_ROOT2/template/redmine_git_hosting_setting_value.sql"
}
export -f redmine_git_hosting_setting_template

function redmine_git_hosting_setting_current {
  "$INSTALL_ROOT/lib/redmine/get_setting_value.sh" 'plugin_redmine_git_hosting'
}
export -f redmine_git_hosting_setting_current

function task_dependencies {
  echo redmine_database_schema
}

export -f task_dependencies

function task_condition {
  return $("$INSTALL_ROOT2/lib/text/diff-commands.sh" 'redmine_git_hosting_setting_template' 'redmine_git_hosting_setting_current')
}
export -f task_condition

function task_execute {
  set -u
  set -e
  local setting_value=$(redmine_git_hosting_setting_template | "$INSTALL_ROOT2/lib/text/escape_single_quotes.sh")
  "$INSTALL_ROOT2/lib/redmine/set_setting_value.sh" 'plugin_redmine_git_hosting' "$setting_value"
}
export -f task_execute

function task_triggers {
  echo redmine_git_hosting_rescue
}
export f task_triggers
