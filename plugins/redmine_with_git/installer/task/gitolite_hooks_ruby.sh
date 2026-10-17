#!/bin/bash

set -u
set -e

function gitolite_hook_path {
  printf '%s/hooks/common/post-receive' "$(programeiro /gitolite/query_rc LOCAL_CODE)"
}

function task_dependencies {
  echo gitolite_admin_base_hooks_clean redmine_bundle redmine_git_hosting_settings
}

function task_condition {
  if bool_r "$SKIP_DATABASE"; then return 0; fi

  local hook_path
  hook_path="$(gitolite_hook_path)"
  if ! sudo -u "$gitolite_user" test -f "$hook_path"; then return 0; fi
  [ "$(sudo -u "$gitolite_user" head -n 1 "$hook_path")" == "#!$(programeiro /ruby/path)" ]
}

function task_fix {
  programeiro /rails/rake redmine_git_hosting:install_hook_files
}
