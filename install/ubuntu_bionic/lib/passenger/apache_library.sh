#!/bin/bash

set -e
set -u

FILE=$("$INSTALL_ROOT2/lib/passenger/root.sh")'/buildout/apache2/mod_passenger.so'

if [ -f "$FILE" ]; then
  echo $FILE
else
  echo ''
fi
