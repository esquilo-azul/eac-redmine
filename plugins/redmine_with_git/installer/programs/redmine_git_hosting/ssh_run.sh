#!/bin/bash

set -e
set -u

var_set_by STRICT_HOST_KEY_CHECKING bool_s "$1" 'yes' 'no'
shift

sudo -u "$(programeiro /rails/user)" \
  ssh -oBatchMode=yes "-oStrictHostKeyChecking=${STRICT_HOST_KEY_CHECKING}" \
  -i "$(programeiro /redmine_git_hosting/ssh_key)" \
  -l "$gitolite_user" \
  "$SSH_SERVER_HOST" \
  "$@"
