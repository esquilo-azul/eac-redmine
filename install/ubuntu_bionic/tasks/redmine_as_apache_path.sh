#!/bin/bash

set -u
set -e

TEMPLATE="$INSTALL_ROOT/template/redmine_as_apache_path.conf"

function task_dependencies {
  echo redmine_as_apache_base redmine_public_link
}
export -f task_dependencies

function task_condition {
  if [ ! -f /etc/apache2/conf-available/redmine.conf ]; then
    return 1
  fi
  if [ ! -f /etc/apache2/conf-enabled/redmine.conf ]; then
    return 1
  fi
  return $("$INSTALL_ROOT/lib/text/template.sh" "$TEMPLATE" | "$INSTALL_ROOT/lib/text/diff-stdin-file.sh" "/etc/apache2/conf-available/redmine.conf" )
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT/lib/text/template.sh" "$TEMPLATE" | sudo tee /etc/apache2/conf-available/redmine.conf > /dev/null
  sudo a2enconf redmine
}
export -f task_execute

function task_triggers {
  echo apache_restart
}
export f task_triggers
