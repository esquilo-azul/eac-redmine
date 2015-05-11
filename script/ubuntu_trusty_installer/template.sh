#!/bin/bash

set -u
set -e

TEMPLATE_FILE=$1

while read line
do
	eval echo "$line"
done < "$TEMPLATE_FILE"
