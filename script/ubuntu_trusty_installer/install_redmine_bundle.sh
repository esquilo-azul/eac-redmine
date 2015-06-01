#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))

bundleInstalled() {
	(cd "$REDMINE_ROOT"; bundle check)	
	return $?
}

"$DIR/apt_get_assert_packages.sh" ruby ruby-dev libmagickwand-dev libxslt1-dev libpq-dev
"$DIR/ruby_assert_gems.sh" bundler
	
if bundleInstalled; then
	echo "Bundle completo"
else
	echo "Bundle incompleto"
	(cd "$REDMINE_ROOT"; bundle install --without development test)
fi
