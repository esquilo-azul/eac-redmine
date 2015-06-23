#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))

bundleInstalled() {
	$REDMINE_ROOT/bin/bundle check
	return $?
}

"$DIR/apt_get_assert_packages.sh" cmake #ruby ruby-dev libmagickwand-dev libxslt1-dev libpq-dev imagemagick
"$DIR/bundle_install.sh"

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
