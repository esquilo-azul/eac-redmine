#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))

bundleInstalled() {
	$REDMINE_ROOT/bin/bundle check
	return $?
}

"$DIR/ruby_assert_gems.sh" bundler
	
if bundleInstalled; then
	echo "Bundle completo"
else
	echo "Bundle incompleto"
	set +e
	$REDMINE_ROOT/bin/bundle install || $REDMINE_ROOT/bin/bundle update
	set -e
fi
