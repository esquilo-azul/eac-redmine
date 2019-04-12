#!/bin/bash

set -u
set -e

function task_condition {
  return $("$INSTALL_ROOT/lib/apt/installed.sh" libpng12-0)
}
export -f task_condition

function task_execute {
  PACKAGE="$(mktemp -d)/libpng12.deb"
  wget -q -O "$PACKAGE" http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb
  sudo dpkg -i "$PACKAGE"
  rm "$PACKAGE"
}
export -f task_execute
