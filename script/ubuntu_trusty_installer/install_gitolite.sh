#!/bin/bash

set -u
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ $# -lt 2 ]; then
    echo "$0" '<REDMINE_USER>' '<GITOLITE_USER>' '<GITOLITE_HOME>' '<SSH_KEY_NAME>' 
    exit -1
fi

REDMINE_USER=$1
GITOLITE_USER=$2
GITOLITE_USER_HOME=$3
SSH_KEY_NAME=$4

# SSH Key
export SSH_KEY=$(eval echo ~${REDMINE_USER})/.ssh/$SSH_KEY_NAME
echo "SSH_KEY=$SSH_KEY"
set +e
sudo -u "$REDMINE_USER" stat "$SSH_KEY" > /dev/null
RESULT=$?
set -e
if [ $RESULT -ne 0 ]; then
    sudo -u "$REDMINE_USER" -H ssh-keygen -t dsa -f "$SSH_KEY" -N ''
fi

# Gitolite
"$DIR/lib/apt/assert_installed.sh" gitolite
"$DIR/assert_user.sh" "$GITOLITE_USER" "$GITOLITE_USER_HOME"
TEMPDIR=$(sudo -u "$REDMINE_USER" mktemp -d)
PUBLICKEY_TEMP="$TEMPDIR/$SSH_KEY_NAME.pub"
sudo -u "$REDMINE_USER" chmod 777 "$TEMPDIR" -R
sudo -u "$REDMINE_USER" cp "$SSH_KEY".pub "$PUBLICKEY_TEMP"
sudo -u "$GITOLITE_USER" -H gl-setup "$PUBLICKEY_TEMP"
sudo -u "$REDMINE_USER" rm -rf "$TEMPDIR"

# Sudo
"$DIR/assert_sudo.sh" "$REDMINE_USER" "$GITOLITE_USER"
"$DIR/assert_sudo.sh" "$GITOLITE_USER" "$REDMINE_USER"

# Configuração do plugin RedmineGitHosting
TEMPLATE=$("$DIR/template.sh" "$DIR/template/redmine_git_hosting_setting_value.sql") 
"$DIR/assert_redmine_setting.sh" plugin_redmine_git_hosting "$TEMPLATE"