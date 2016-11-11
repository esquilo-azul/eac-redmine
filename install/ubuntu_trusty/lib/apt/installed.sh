#!/bin/bash

set -u
set -h

INSTALL='0'
for PKG in $@; do
    RESULT=`dpkg-query -W '-f=${Status}' "$PKG"`
    if [ "$RESULT" != 'install ok installed' ] ; then        
        INSTALL='1'
    fi
done
echo $INSTALL