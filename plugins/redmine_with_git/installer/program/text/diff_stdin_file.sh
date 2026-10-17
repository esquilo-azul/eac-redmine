#!/bin/bash

set -u
set -e

if [ -f "$1" ]; then
  set +e
  diff "/dev/stdin" "$1" > /dev/null
  result=$?
  set -e
  echo $result
else
  echo 9999
fi
