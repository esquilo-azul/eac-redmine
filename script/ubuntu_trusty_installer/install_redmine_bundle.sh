#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))

bundleInstalled() {
	(cd "$REDMINE_ROOT"; bundle check)	
	return $?
}

"$DIR/apt_get_assert_packages.sh" ruby ruby-dev libmagickwand-dev libxslt1-dev libpq-dev imagemagick
"$DIR/ruby_assert_gems.sh" bundler
	
if bundleInstalled; then
	echo "Bundle completo"
else
	echo "Bundle incompleto"
	(cd "$REDMINE_ROOT"; bundle install --without development test)
fi

SECRETS_FILE="$REDMINE_ROOT/config/secrets.yml"

if [ ! -f "$SECRETS_FILE" ]; then
	echo "Arquivo de tokens não existe. Criando..."
	SECRET_TOKEN=$("$DIR/generate_secret.sh")
	cat <<EOF > "$SECRETS_FILE"
development:
  secret_key_base: $SECRET_TOKEN

test:
  secret_key_base: $SECRET_TOKEN

production:
  secret_key_base: $SECRET_TOKEN

EOF

fi
