#!/bin/bash

set -u
set +e
echo $1 | grep '^[a-z]\+\(_[a-z]\+\)\{0,\}$' > /dev/null
result=$?
set -e
echo $result