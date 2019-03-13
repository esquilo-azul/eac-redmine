#!/bin/bash

set -u
set -e

INSTALL='0'
for PKG in $@; do
    set +e
    RESULT=`dpkg-query -W '-f=${Status}' "$PKG"`
    set -e
    if [ "$RESULT" != 'install ok installed' ] ; then
        INSTALL='1'
    fi
done
echo $INSTALL
