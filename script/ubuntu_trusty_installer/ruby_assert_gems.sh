#!/bin/bash

set -u
set -h

gemInstalled() {
	GEM=$1
	TEST=$(gem list --local | grep -io '^[0-9a-z\-]\+' | grep -i "^$GEM\$")
	if [ -z "$TEST" ]; then
		return 1
	else
		return 0
	fi
}

INSTALL=''
for GEM in $@; do
	if gemInstalled "$GEM"; then
		echo "Gem \"$GEM\" is already installed"
    else
		echo "Gem \"$GEM\" is not installed"
        INSTALL=" $GEM $INSTALL"        
	fi
done

if [ ! -z "$INSTALL" ]; then
    echo "Será necessário instalar os seguintes ruby gems: $INSTALL"
	gem install -V --conservative $INSTALL 
fi