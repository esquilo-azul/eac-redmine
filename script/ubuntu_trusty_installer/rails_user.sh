#!/bin/bash

# Referência: https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerUser

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REDMINE_ROOT=$(dirname $(dirname "$DIR"))

stat -c '%U' "$REDMINE_ROOT/config/environment.rb"