#!/bin/bash

set -e
set -u

eval echo ~$(programeiro /rails/user)/.ssh/$redmine_git_hosting_ssh_key_name
