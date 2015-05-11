#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ $# -lt 2 ]; then
    echo "$0" '<USER2>' '<USER2>'
    exit -1
fi

USER1=$1
USER2=$2
LINE="$USER1    ALL=($USER2) NOPASSWD:ALL"

sudo "$DIR/append_line.sh" "$LINE" '/etc/sudoers'