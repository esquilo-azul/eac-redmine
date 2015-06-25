#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))

(cd $REDMINE_ROOT; bundle exec rake secret 2> /dev/null)