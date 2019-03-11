#!/bin/bash

set -e
set -u

"$INSTALL_ROOT/lib/linux/locale/current.sh" | while read l; do
  TARGET=$(printf "$l" | sed 's/-//g' )
  PATTERN="^${TARGET}\$"
  if ! locale -a | grep -i "$PATTERN" > /dev/null ; then
    echo "$l"
  fi
done
