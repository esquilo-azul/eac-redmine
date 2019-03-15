#!/bin/bash

set -u
set -e

SUDOER_FILE="/etc/sudoers.d/$("$INSTALL_ROOT/lib/rails/user.sh")_redmine_with_git"

function task_dependencies {
  echo gitolite_user
}

export -f task_dependencies

function task_condition {
  if [ "$("$INSTALL_ROOT/lib/linux/sudo_file_exists.sh" "root" "$SUDOER_FILE")" != '0' ]; then
    return 1
  fi
  export rails_user="$("$INSTALL_ROOT/lib/rails/user.sh")"
  result=$("$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_user_sudoer" | sudo "$INSTALL_ROOT/lib/text/diff-stdin-file.sh" "$SUDOER_FILE")
  if [ "$result" != '0' ]; then
    return 1
  fi
  if [ "$(sudo stat -c "%a" "$SUDOER_FILE")" != '440' ]; then
    return 1
  fi
}
export -f task_condition

function task_execute {
  set -u
  set -e
  export rails_user="$("$INSTALL_ROOT/lib/rails/user.sh")"
  "$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_user_sudoer" | sudo tee "$SUDOER_FILE" > /dev/null
  sudo chmod 440 "$SUDOER_FILE"
}
export -f task_execute
