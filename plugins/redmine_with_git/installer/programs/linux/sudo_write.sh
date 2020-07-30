#!/bin/bash

set -e
set -u

if [ $# -lt 1 ]; then
  printf "Usage: $0 <TARGET_FILE>"
  exit 1
fi

if [ $(id -u) -eq 0 ]; then
  TARGET_FILE="$1"
  EDITOR='tee' visudo -f "$TARGET_FILE" <&0
  chmod 440 "$TARGET_FILE"
else
  sudo "$0" "$@"
fi
