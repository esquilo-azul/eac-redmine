#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

DATABASE=$1
USER=$2
PASSWORD=$3

userExists() {
	TEST=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$1'")
	if [ -n "$TEST" -a "$TEST" == '1' ]; then
		return 0
	else
		return 1
	fi
}

createUser() {
	sudo -u postgres psql -c "CREATE ROLE $1 LOGIN ENCRYPTED PASSWORD '$2' NOINHERIT VALID UNTIL 'infinity';" > /dev/null
}

alterPassword() {
	sudo -u postgres psql -c "ALTER ROLE $1 PASSWORD '$2';" > /dev/null
}

databaseExists() {
	TEST=$(sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -w redmine | wc -l)
	if [ -n "$TEST" -a "$TEST" == '1' ]; then
		return 0
	else
		return 1
	fi
}

createDatabase() {
	sudo -u postgres psql -c "CREATE DATABASE $1 WITH ENCODING='UTF8' OWNER=$2;" > /dev/null
}

changeDatabaseOwner() {
	sudo -u postgres psql -c "ALTER DATABASE $1 OWNER TO $2;" > /dev/null
}

echo "POSTGRESQL: Instalando pacotes Debian..."
"$DIR/lib/apt/assert_installed.sh" postgresql
echo "POSTGRESQL: pacotes debian instalados"

if userExists $USER; then
	echo "POSTGRESQL: Usuário PostgreSQL \"$USER\" já existe. Alterando senha..."
	alterPassword $USER $PASSWORD	
else
	echo "POSTGRESQL: Usuário PostgreSQL \"$USER\" não existe. Criando..."
	createUser $USER $PASSWORD
fi

if databaseExists $DATABASE; then
	echo "POSTGRESQL: Banco PostgreSQL \"$DATABASE\" já existe. Alterando proprietário..."
	changeDatabaseOwner $DATABASE $USER
else
	echo "POSTGRESQL: Banco PostgreSQL \"$DATABASE\" não existe. Criando..."
	createDatabase $DATABASE $USER
fi

echo "POSTGRESQL: Aplicando parâmetros de conexão da base de dados PostgreSQL ao Redmine..."
DATABASE_CONFIG_FILE=$(dirname $(dirname "$DIR"))'/config/database.yml'
cat <<HERE > "$DATABASE_CONFIG_FILE"
production:
  adapter: postgresql
  database: $DATABASE
  host: localhost
  username: $USER
  password: $PASSWORD
  encoding: utf8

development:
  adapter: postgresql
  database: $DATABASE
  host: localhost
  username: $USER
  password: $PASSWORD
  encoding: utf8
HERE
echo "Concluído"