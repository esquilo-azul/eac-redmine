#!/bin/bash

set -e
set -u

sudo -u "$(programeiro /rails/user)" \
  ssh -oBatchMode=yes -oStrictHostKeyChecking=no \
  -i "$(programeiro /redmine_git_hosting/ssh_key)" \
  -l "$gitolite_user" \
  localhost \
  "$@"
