#!/bin/bash

set -u
set -e

function task_condition {
  if [ ! -f "$REDMINE_ROOT/config/secrets.yml" ]; then
    return 1
  fi
}
export -f task_condition

function task_execute {
  export secret_key_base=$("$INSTALL_ROOT/lib/rails/generate_secret_key.sh")
  "$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_secrets.yml" > "$REDMINE_ROOT/config/secrets.yml"
}
export -f task_execute
