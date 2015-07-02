#!/bin/bash

set -u
set -e

out_tmp=$(mktemp)
in_tmp=$(mktemp)

cp "$1" "$in_tmp"
cp "$1" "$out_tmp"

for var in $("$INSTALL_ROOT/lib/text/variables.sh" "$1"); do	
	if [ -z ${!var+x} ]; then 
		echo "Variable \"$var\" is unset"
		exit 1
	fi 
	sed -e "s|\${$var}|${!var}|" "$in_tmp" > "$out_tmp"
	cp "$out_tmp" "$in_tmp"
done

cat "$out_tmp"