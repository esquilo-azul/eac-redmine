#!/bin/bash

set -u
set -e

"$INSTALL_ROOT/lib/postgresql/execute_sql.sh" "select value from settings where name='$1'"
