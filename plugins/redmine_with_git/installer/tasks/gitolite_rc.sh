#!/bin/bash

set -u
set -e

gitolite_rc_file="$gitolite_user_home/.gitolite.rc"

function gitolite_rc_template {
  programeiro /template/apply "${REDMINE_WITH_GIT_TEMPLATE_ROOT}/gitolite.rc"
}

function task_dependencies {
  echo gitolite_user_home
}

function task_condition {
  temprc="$(sudo -u "$gitolite_user" mktemp)"
  sudo -u "$gitolite_user" cp "$gitolite_user_home/.gitolite.rc" "$temprc"
  sudo -u "$gitolite_user" chmod 777 "$temprc"
  if [ "$(gitolite_rc_template | programeiro /text/diff_stdin_file "$temprc" )" -ne 0 ]; then
    return 1
  fi
}

function task_fix {
  gitolite_rc_template | sudo -u "$gitolite_user" tee "$gitolite_user_home/.gitolite.rc" > /dev/null
  programeiro /redmine/installer/triggers/set 'redmine_git_hosting_rescue'
}
