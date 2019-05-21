#!/bin/bash

set -e
set -u

if [ "$("$INSTALL_ROOT2/lib/text/valid_check_name.sh" "$2")" -ne 0 ]; then
  echo "Invalid item name: \"$2\""
  exit 1
fi

set +e
echo "$1" | grep "$2|" > /dev/null
result=$?
set -e
echo $result
