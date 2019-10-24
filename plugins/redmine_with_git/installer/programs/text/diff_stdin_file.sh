#!/bin/bash

set -u
set -e

set +e
diff "/dev/stdin" "$1" > /dev/null
result=$?
set -e
echo $result
