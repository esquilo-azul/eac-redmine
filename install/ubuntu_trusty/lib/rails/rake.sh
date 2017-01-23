#!/bin/bash

set -u
set -e

(cd $REDMINE_ROOT; bundle exec rake "$@")