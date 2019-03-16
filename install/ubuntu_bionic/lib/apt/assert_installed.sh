#!/bin/bash

set -u
set -h

INSTALL=''
for PKG in $@; do
    RESULT="$("$INSTALL_ROOT/lib/apt/installed.sh" "$PKG")"
    if [ "$RESULT" != '0' ] ; then
        echo "Package \"$PKG\" is not installed"
        INSTALL=" $PKG $INSTALL"
    fi
done

if [ ! -z "$INSTALL" ]; then
    echo "Será necessário instalar os seguintes pacotes debian: $INSTALL"
    sudo apt-get -y install $INSTALL
fi
