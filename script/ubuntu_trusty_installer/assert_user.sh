#!/bin/bash

set -u
set -e

if [ $# -lt 1 ]; then
    echo "Uso: $0 <LOGIN>"
    exit -1
fi

LOGIN=$1

if id -u "$LOGIN" >/dev/null 2>&1; then
        echo "Usuário "$LOGIN" já existe"
else
        echo "Usuário "$LOGIN" não existe"
        COMMAND="sudo useradd --system"
        if [ $# -ge 2 ]; then
        	COMMAND="$COMMAND --home-dir $2" 
        fi       
        $COMMAND "$LOGIN"        
fi

HOME_DIR=$(eval echo ~${LOGIN})
if [ -d "$HOME_DIR" ]; then
    echo 'Diretório "'$HOME_DIR'" já existe'
else
    echo 'Diretório "'$HOME_DIR'" não existe'
    sudo mkdir "$HOME_DIR"
    sudo chown "$LOGIN:$LOGIN" "$HOME_DIR"
fi