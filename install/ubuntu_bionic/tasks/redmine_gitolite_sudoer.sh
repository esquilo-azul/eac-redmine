#!/bin/bash

set -u
set -e

SUDOER_FILE="/etc/sudoers.d/$(programeiro /rails/user)_redmine_with_git"

function task_dependencies {
  echo gitolite_user
}

export -f task_dependencies

function task_condition {
  if [ "$("$INSTALL_ROOT2/lib/linux/sudo_file_exists.sh" "root" "$SUDOER_FILE")" != '0' ]; then
    return 1
  fi
  export rails_user="$(programeiro /rails/user)"
  result=$(programeiro /template/apply "$INSTALL_ROOT2/template/redmine_user_sudoer" | sudo programeiro /text/diff_stdin_file "$SUDOER_FILE")
  if [ "$result" != '0' ]; then
    return 1
  fi
  if [ "$(sudo stat -c "%a" "$SUDOER_FILE")" != '440' ]; then
    return 1
  fi
}
export -f task_condition

function task_fix {
  set -u
  set -e
  export rails_user="$(programeiro /rails/user)"
  programeiro /template/apply "$INSTALL_ROOT2/template/redmine_user_sudoer" | sudo tee "$SUDOER_FILE" > /dev/null
  sudo chmod 440 "$SUDOER_FILE"
}
export -f task_fix
