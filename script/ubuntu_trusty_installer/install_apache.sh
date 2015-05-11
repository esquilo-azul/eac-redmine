#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

passengerRoot() {
	DIR=$(echo /var/lib/gems/*/gems/passenger-*)	
	if [ -d "$DIR" ]; then
		echo $DIR
	else
		echo ''
	fi
}

passengerPath() {
	FILE=$(passengerRoot)'/buildout/apache2/mod_passenger.so'
	if [ -f "$FILE" ]; then
		echo $FILE
	else
		echo ''
	fi
}

echo "PASSENGER: instalando pacotes Debian..."
"$DIR/apt_get_assert_packages.sh" libcurl4-openssl-dev libssl-dev apache2-dev libapr1-dev libaprutil1-dev libxslt1-dev ruby apache2
echo 'PASSENGER: instalando gem "passenger"...'
"$DIR/ruby_assert_gems.sh" passenger

if [ -z $(passengerPath) ]; then
	echo "PASSENGER: módulo não existe. Criando..."
	sudo passenger-install-apache2-module -a
	if [ -z $(passengerPath) ]; then
		exit
	fi
else
	echo "PASSENGER: módulo já existe (\"$(passengerPath)\")"
fi

echo "PASSENGER: configurando módulo Apache..."
echo LoadModule passenger_module "$(passengerPath)" | sudo tee /etc/apache2/mods-available/passenger.load > /dev/null
echo "
<IfModule mod_passenger.c>
     PassengerRoot $(passengerRoot)
     PassengerDefaultRuby /usr/bin/ruby
</IfModule>" | sudo tee /etc/apache2/mods-available/passenger.conf > /dev/null

echo "PASSENGER: habilitando módulo Apache..."
sudo a2enmod passenger
	
PUBLIC_DIR=$(dirname $(dirname "$DIR"))'/public/'
LINK=/var/www/html/redmine
echo $(readlink "$LINK")
echo "$PUBLIC_DIR"
if [ -e "$LINK" -a $(readlink "$LINK") != "$PUBLIC_DIR" ]; then
	echo "Caminho \"$LINK\" já existe, mas não aponta para \"$PUBLIC_DIR\". Removendo..."
	rm "$LINK"
fi
	
if [ -e "$LINK" ]; then
	echo "Link \"$LINK\" já existe."
else
	echo "Link \"$LINK\" não existe. Criando..."
	sudo ln -s "$PUBLIC_DIR" "$LINK"
fi
echo 'RailsBaseUri "/redmine"' | sudo tee /etc/apache2/conf-available/redmine.conf
sudo a2enconf redmine
sudo service apache2 restart