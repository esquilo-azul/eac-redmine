#!/bin/bash

set -u

set +e
sudo service "$1" status > /dev/null 2> /dev/null
RESULT=$?
set -e

echo "$RESULT"
