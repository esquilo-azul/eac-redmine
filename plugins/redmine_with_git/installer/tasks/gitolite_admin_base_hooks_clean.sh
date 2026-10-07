#!/bin/bash

set -u
set -e

RESIDUAL_HOOKS=(post-receive post-receive.d lib)

function gitolite_admin_base_hooks_dir {
  printf '%s/hooks/common' "$(programeiro /gitolite/query_rc GL_ADMIN_BASE)"
}

function task_dependencies {
  echo gitolite_setup
}

function task_condition {
  local dir
  dir="$(gitolite_admin_base_hooks_dir)"
  for hook in "${RESIDUAL_HOOKS[@]}"; do
    if sudo -u "$gitolite_user" test -e "$dir/$hook"; then
      return 1
    fi
  done
}

function task_fix {
  local dir
  dir="$(gitolite_admin_base_hooks_dir)"
  for hook in "${RESIDUAL_HOOKS[@]}"; do
    sudo -u "$gitolite_user" rm -rf "$dir/$hook"
  done
  sudo -u "$gitolite_user" -H gitolite setup --hooks-only
}
