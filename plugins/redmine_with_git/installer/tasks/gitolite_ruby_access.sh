#!/bin/bash

set -u
set -e

function task_dependencies {
  echo gitolite_user ruby
}

function task_condition {
  sudo -u "$gitolite_user" "$(programeiro /ruby/path)" -v > /dev/null 2>&1
}

function task_fix {
  local ruby_path
  ruby_path="$(programeiro /ruby/path)"
  infom "User \"$gitolite_user\" cannot execute \"$ruby_path\"" \
    "(required by Gitolite hooks)."
  infom "Grant traverse permission to the blocking directories. Run" \
    "\"sudo -u $gitolite_user namei -l $ruby_path\" to find them."
}
