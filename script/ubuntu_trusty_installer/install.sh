#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))
DEFAULT_SETTINGS="$REDMINE_ROOT/config/install-settings.sh"

if [ $# -ge 1 ]; then
	SETTINGS_FILE=$1
else
	SETTINGS_FILE=$DEFAULT_SETTINGS
fi

if [ ! -f "$SETTINGS_FILE" ]; then
	echo "Uso:"
	echo ""
	echo "    $0 [ARQUIVO_PARAMETROS]"
	echo ""	
	echo "Se não especificado, ARQUIVO_PARAMETROS utiliza a localização padrão abaixo:"
	echo ""
	echo "    $DEFAULT_SETTINGS"
	echo ""
	echo "O arquivo \"$SETTINGS_FILE\" não existe. Para corrigir..."
	echo ""
	echo "    cp '$DEFAULT_SETTINGS' '$SETTINGS_FILE'"
	echo ""
	echo "... E edite '$SETTINGS_FILE' de acordo com seu ambiente."
	echo ""
	exit
fi

source "$SETTINGS_FILE"
$DIR/install_postgresql.sh "$postgresql_database" "$postgresql_user" "$postgresql_password"
$DIR/install_redmine_bundle.sh
$DIR/install_redmine.sh