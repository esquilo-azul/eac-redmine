#!/bin/bash

if [ $# -lt 2 ]; then
    echo "$0" '<LINE>' '<FILE>'
    exit -1
fi

LINE=$1
FILE=$2

grep -Fxq "$LINE" "$FILE"
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo "$LINE" >> "$FILE"
    echo "Linha adicionada" 1>&2
else
    echo "Linha já existe" 1>&2
fi