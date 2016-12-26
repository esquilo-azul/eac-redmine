#!/bin/bash

set -u
set -e

RESULT=$(service "$1" status)

set +e
echo $RESULT | grep -i down > /dev/null
DOWN=$?
echo $RESULT | grep -i online > /dev/null
UP=$?
set -e

if [ "$UP" -eq 0 ]; then
  echo '0'
  exit 0
fi

if [ "$DOWN" -eq 0 ]; then
  echo '1'
  exit 0
fi

2>&1 echo "Status unknown: $RESULT"
exit 1
