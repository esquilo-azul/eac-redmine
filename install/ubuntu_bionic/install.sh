#!/bin/bash

set -u
set -e

function trigger_apache_restart {
  sudo service apache2 restart
}
export -f trigger_apache_restart

function trigger_redmine_git_hosting_rescue {
  "$INSTALL_ROOT2/lib/rails/rake.sh" redmine_with_git:rescue
}
export -f trigger_redmine_git_hosting_rescue

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/environment.sh"

if [ -z "$TASK" ]; then
  >&2 echo "Usage: $0 --task <TASK>"
  >&2 echo "<TASK>: development|redmine_as_apache_base|redmine_as_apache_path"
  exit 1
fi
"$INSTALL_ROOT2/lib/tasks/run_target.sh" $TASK
