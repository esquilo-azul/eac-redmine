#!/bin/bash

set -e
set -u

eval echo ~$("$INSTALL_ROOT/lib/rails/user.sh")/.ssh/$redmine_git_hosting_ssh_key_name