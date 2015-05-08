#!/bin/bash

set -u
set -h

INSTALL=''
for PKG in $@; do
    RESULT=`dpkg-query -W '-f=${Status}' "$PKG"`
    if [ "$RESULT" != 'install ok installed' ] ; then
        echo "Package \"$PKG\" is not installed"
        INSTALL=" $PKG $INSTALL"
    else
        echo "Package \"$PKG\" is already installed"
    fi
done

if [ ! -z "$INSTALL" ]; then
    echo "Será necessário instalar os seguintes pacotes debian: $INSTALL"
    sudo apt-get -y install $INSTALL
fi