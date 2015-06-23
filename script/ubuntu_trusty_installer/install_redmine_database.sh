#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))

"$REDMINE_ROOT/bin/bundle" exec rake trf1_sjap:fix_redmine_git_hosting_migrations
(cd $REDMINE_ROOT; bundle exec rake db:migrate)
(cd $REDMINE_ROOT; bundle exec rake redmine:plugins:migrate)
