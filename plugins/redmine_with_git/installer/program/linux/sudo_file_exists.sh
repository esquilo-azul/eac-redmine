#!/bin/bash

set -e
set -u

user=$1
file=$2

set +e
sudo -u "$user" stat "$file" > /dev/null
echo $?
