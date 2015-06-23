#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

"$DIR/apt_get_assert_packages.sh" curl

RVM_SOURCE=~/.rvm/scripts/rvm

if [ ! -f "$RVM_SOURCE" ]; then
	echo 'RVM não instalado. Instalando...'
	\curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles
fi

set +u
set +e
source "$RVM_SOURCE"
rvm $@