#!/bin/bash

set -u
set -e

source "$INSTALL_ROOT2/lib/rvm/source.sh"

function task_condition {
  if [ ! -f ~/.rvm/bin/rvm ]; then
    return 1
  fi
}
export -f task_condition

function task_execute {
  "$INSTALL_ROOT2/lib/apt/assert_installed.sh" curl
  \curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles
}
export -f task_execute
