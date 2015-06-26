#!/bin/bash

set -u
set -e

function trigger_apache_restart {
	sudo service apache2 restart
}
export -f trigger_apache_restart

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/environment.sh"
"$INSTALL_ROOT/lib/tasks/run_target.sh" all