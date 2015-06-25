#!/bin/bash

set -u
set -e

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/environment.sh"
"$INSTALL_ROOT/lib/tasks/run_target.sh" all