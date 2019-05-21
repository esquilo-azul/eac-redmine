#!/bin/bash

set -u
set -e

"$INSTALL_ROOT2/lib/postgresql/execute_sql.sh" "select value from settings where name='$1'"
