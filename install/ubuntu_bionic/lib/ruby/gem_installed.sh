#!/bin/bash

set -u
set -e

GEM=$1
TEST=$(gem list --local | grep -io '^[0-9a-z\-]\+' | grep -i "^$GEM\$")
if [ -z "$TEST" ]; then
  echo '1'
else
  echo '0'
fi
