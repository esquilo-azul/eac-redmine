#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

RUBIE='ruby-2.2'

set +e
$DIR/rvm.sh list | grep "$RUBIE"
FOUND=$?
set -e

if [[ "$FOUND" -ne 0 ]]; then
	echo "Ruby não instalado. Instalando..."
	$DIR/rvm.sh install "$RUBIE"
else
	echo "Ruby instalado"
fi

source $DIR/rvm.sh use "$RUBIE"
gem -v
#"$DIR/ruby_assert_gems.sh" bundler

