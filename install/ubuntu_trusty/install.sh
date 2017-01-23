#!/bin/bash

set -u
set -e

function trigger_apache_restart {
	sudo service apache2 restart
}
export -f trigger_apache_restart

function trigger_redmine_git_hosting_rescue {
  "$INSTALL_ROOT/lib/rails/rake.sh" redmine_git_hosting:install_hook_parameters \
    redmine_git_hosting:migration_tools:update_repositories_type \
    redmine_git_hosting:install_hook_files redmine_git_hosting:fetch_changesets
}
export -f trigger_redmine_git_hosting_rescue

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/environment.sh"
"$INSTALL_ROOT/lib/tasks/run_target.sh" $TASK