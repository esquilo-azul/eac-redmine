#!/bin/bash

set -u
set -e

function redmine_git_hosting_setting_template {
  export redmine_git_hosting_ssh_key=$(programeiro /redmine_git_hosting/ssh_key)
  programeiro /template/apply "${REDMINE_WITH_GIT_TEMPLATE_ROOT}/redmine_git_hosting_setting_value.sql" -
}
export -f redmine_git_hosting_setting_template

function redmine_git_hosting_setting_current {
  programeiro /redmine/setting/read 'plugin_redmine_git_hosting'
}
export -f redmine_git_hosting_setting_current

function task_dependencies {
  echo redmine_database_schema
}

function task_condition {
  if bool_r "$SKIP_DATABASE"; then return 0; fi

  return $(programeiro /text/diff_commands 'redmine_git_hosting_setting_template' 'redmine_git_hosting_setting_current')
}

function task_fix {
  programeiro /redmine/setting/write 'plugin_redmine_git_hosting' \
    "$(redmine_git_hosting_setting_template)"
  programeiro /redmine/installer/triggers/set 'redmine_git_hosting_rescue'
}
