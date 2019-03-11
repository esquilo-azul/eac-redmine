#!/bin/bash

set -u
set -e

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
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_as_apache_path.conf" | sudo tee /etc/apache2/conf-available/redmine.conf > /dev/null
  sudo a2enconf redmine
}
export -f task_execute

function task_triggers {
  echo apache_restart
}
export f task_triggers
