#!/bin/bash

set -e
set -u

result=$1
if [ $("$INSTALL_ROOT/lib/text/checked.sh" "$1" "$2") -ne 0 ]; then
	result="$result""$2"'|'
fi
echo $result