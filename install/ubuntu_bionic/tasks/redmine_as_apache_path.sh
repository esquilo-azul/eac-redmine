#!/bin/bash

set -u
set -e

TEMPLATE="$INSTALL_ROOT/template/redmine_as_apache_path.conf"
AVAILABLE_PATH="/etc/apache2/conf-available/${instance_id}.conf"
ENABLED_PATH="/etc/apache2/conf-enabled/${instance_id}.conf"

function task_dependencies {
  echo redmine_as_apache_base redmine_public_link
}
export -f task_dependencies

function task_condition {
  if [ ! -f "$AVAILABLE_PATH" ]; then
    return 1
  fi
  if [ ! -f "$ENABLED_PATH" ]; then
    return 1
  fi
  return $("$INSTALL_ROOT/lib/text/template.sh" "$TEMPLATE" | "$INSTALL_ROOT/lib/text/diff-stdin-file.sh" "$AVAILABLE_PATH" )
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT/lib/text/template.sh" "$TEMPLATE" | sudo tee "$AVAILABLE_PATH" > /dev/null
  sudo a2enconf "$instance_id"
}
export -f task_execute

function task_triggers {
  echo apache_restart
}
export f task_triggers
