#!/bin/bash

set -u
set -e

function enabled_scm_setting_template {
  cat "${REDMINE_WITH_GIT_TEMPLATE_ROOT}/redmine_enabled_scm_setting_value"
}
export -f enabled_scm_setting_template

function enabled_scm_setting_current {
  programeiro /redmine/get_setting_value 'enabled_scm'
}
export -f enabled_scm_setting_current

function task_dependencies {
  echo redmine_database_schema redmine_git_hosting_settings gitolite_rc
}

function task_condition {
  return $(programeiro /text/diff_commands 'enabled_scm_setting_template' 'enabled_scm_setting_current')
}

function task_fix {
  set -u
  set -e
  local setting_value=$(enabled_scm_setting_template | programeiro /text/escape_single_quotes)
  programeiro /redmine/set_setting_value 'enabled_scm' "$setting_value"
}
