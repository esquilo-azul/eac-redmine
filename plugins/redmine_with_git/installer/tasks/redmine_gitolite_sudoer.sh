#!/bin/bash

set -u
set -e

SUFFIX=''
if [ -n "$address_path" ]; then
  SUFFIX="_$(printf "$address_path" | sed -e 's/^\///')"
fi
export SUDOER_FILE_BASENAME="$(programeiro /rails/user)_redmine_with_git${SUFFIX}"
export SUDOER_FILE="/etc/sudoers.d/${SUDOER_FILE_BASENAME}"
export SUDOER_TMP_FILE="/tmp/${SUDOER_FILE_BASENAME}"

function sudoers_file_copy_file() {
  sudo cp "$SUDOER_FILE" "$SUDOER_TMP_FILE"
  sudo chmod og+r "$SUDOER_TMP_FILE"
  printf "$SUDOER_TMP_FILE\n"
}

function task_dependencies {
  echo gitolite_user
}

export -f task_dependencies

function task_condition {
  if [ "$(programeiro /linux/sudo_file_exists "root" "$SUDOER_FILE")" != '0' ]; then
    return 1
  fi
  export rails_user="$(programeiro /rails/user)"
  SUDOERS_FILE_COPY="$(sudoers_file_copy_file)"
  result=$(template_apply "${REDMINE_WITH_GIT_TEMPLATE_ROOT}/redmine_user_sudoer" | programeiro /text/diff_stdin_file "$SUDOERS_FILE_COPY")
  sudo rm -f "$SUDOERS_FILE_COPY"
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
  template_apply "$REDMINE_WITH_GIT_TEMPLATE_ROOT/redmine_user_sudoer" | \
    programeiro /linux/sudo_write "$SUDOER_FILE"
}
export -f task_fix
