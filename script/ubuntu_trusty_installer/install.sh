#!/bin/bash

set -u
set -e

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

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))
SAMPLE_SETTINGS="$DIR/default-settings.sh"
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

export postgresql_database
export gitolite_user
export gitolite_user_home
$DIR/install_postgresql.sh "$postgresql_database" "$postgresql_user" "$postgresql_password"
$DIR/install_ruby.sh
$DIR/install_redmine_bundle.sh
$DIR/install_redmine_database.sh
$DIR/install_gitolite.sh "$($DIR/rails_user.sh)" "$gitolite_user" "$gitolite_user_home" 'redmine_git_hosting_id'
$DIR/install_apache.sh