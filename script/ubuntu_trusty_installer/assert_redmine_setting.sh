#!/bin/bash

set -u
set -e

settingValue() {
	sudo -u postgres psql -tAc "select value from settings where name='$1'" "$postgresql_database"
}

settingSetted() {
	TEST=$(sudo -u postgres psql -tAc "select 1 from settings where name='$1'" "$postgresql_database")
	if [ -n "$TEST" -a "$TEST" == '1' ]; then
		return 0
	else
		return 1
	fi
}

createSetting() {
	sudo -u postgres psql -c 'insert into settings(name,value,updated_on) values ('\'"$1"\'', '\'"$2"\'', current_timestamp)' "$postgresql_database"
}

updateSetting() {	
	sudo -u postgres psql -tAc 'update settings set value='\'"$2"\'', updated_on=current_timestamp where name='\'"$1"\' "$postgresql_database"
}

SETTING_NAME=$1
SETTING_VALUE=$2

if settingSetted "$1"; then
	echo "Configuração já existe"
	VALUE=$(settingValue "$SETTING_NAME")
	if [ "$VALUE" != "$SETTING_VALUE" ]; then
		echo "Valor diferente. Atualizando..."
		updateSetting "$SETTING_NAME" "$SETTING_VALUE"
	else
		echo "Valor permanece igual" 
	fi
else
	echo "Configuração não existe. Inserindo..."
	createSetting "$SETTING_NAME" "$SETTING_VALUE"
fi