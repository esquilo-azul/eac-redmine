#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))

FILES=("$REDMINE_ROOT/plugins/redmine_git_hosting/config/routes.rb" "$REDMINE_ROOT/plugins/redmine_git_hosting/init.rb")
TOTAL=${#FILES[*]}
for (( i=0; i<=$(( $TOTAL -1 )); i++ ))
do
	TEMPFILES[$i]=$(mktemp)
	cp "${FILES[$i]}" "${TEMPFILES[$i]}"
	rm -f "${FILES[$i]}"
done

(cd $REDMINE_ROOT; bundle exec rake db:migrate)

TOTAL=${#FILES[*]}
for (( i=0; i<=$(( $TOTAL -1 )); i++ ))
do
	mv "${TEMPFILES[$i]}" "${FILES[$i]}"
	TEMPFILES[$i]=$(mktemp)
done


(cd $REDMINE_ROOT; bundle exec rake redmine:plugins:migrate)
