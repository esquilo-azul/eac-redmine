#!/bin/bash

printHelp() {
	echo "Uso:"
	echo ""
	echo "    $0 [OPCOES] [ARQUIVO]"
	echo ""
	echo "Opções:"
	echo ""
	echo "    -h, --help: mostra este texto."
	echo ""
	echo "Argumentos:"
	echo ""
	echo "    ARQUIVO: arquivo com parâmetros de instalação."
	echo ""
	echo "Os seguintes arquivos são lidos na ordem que seguem caso existam:"
	echo "    \"$SAMPLE_SETTINGS\""
	echo "    \"$DEFAULT_SETTINGS\""
	echo "    [ARQUIVO]"
	echo ""
}

export INSTALL_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export REDMINE_ROOT=$(dirname $(dirname "$INSTALL_ROOT"))
SAMPLE_SETTINGS="$INSTALL_ROOT/default-settings.sh"
DEFAULT_SETTINGS="$REDMINE_ROOT/config/install-settings.sh"

if [ $# -ge 1 ]; then
	SETTINGS_FILE=$1
else
	SETTINGS_FILE=''
fi

if [ "$SETTINGS_FILE" == '--help' -o "$SETTINGS_FILE" == '-h' ]; then
	printHelp
	exit
fi

SETTINGS=("$SAMPLE_SETTINGS")

if [ -f "$DEFAULT_SETTINGS" ]; then
	SETTINGS+=("$DEFAULT_SETTINGS")
fi

if [ $# -ge 1 ]; then
	if [ -f "$SETTINGS_FILE" ]; then
		SETTINGS+=("$SETTINGS_FILE")
	else
		echo "\"$SETTINGS_FILE\" não existe."
		exit 1	
	fi
fi

for S in "${SETTINGS[@]}"
do
	source "$S"
done

export PATH="$(dirname "$("$INSTALL_ROOT/lib/ruby/path.sh")"):$PATH"