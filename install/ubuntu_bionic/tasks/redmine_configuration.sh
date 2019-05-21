#!/bin/bash

set -u
set -e

function task_condition {
  return $("$INSTALL_ROOT2/lib/text/template.sh" "$INSTALL_ROOT2/template/redmine_configuration.yml" | "$INSTALL_ROOT2/lib/text/diff-stdin-file.sh" "$REDMINE_ROOT/config/configuration.yml" )
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT2/lib/text/template.sh" "$INSTALL_ROOT2/template/redmine_configuration.yml" > "$REDMINE_ROOT/config/configuration.yml"
}
export -f task_execute

function task_triggers {
  echo apache_restart
}
export f task_triggers
