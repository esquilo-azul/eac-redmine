#!/bin/bash

set -u
set -e

sudo -u "$gitolite_user" -H gitolite query-rc "$1"
