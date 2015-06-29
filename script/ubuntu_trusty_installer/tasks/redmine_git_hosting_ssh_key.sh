#!/bin/bash

set -u
set -e

redmine_user=$("$INSTALL_ROOT/lib/rails/user.sh")
ssh_key=$("$INSTALL_ROOT/lib/redmine_git_hosting/ssh_key.sh")

function task_condition {
	set +e
	sudo -u "$redmine_user" stat "$ssh_key" > /dev/null
	local result=$?
	return $result
}
export -f task_condition

function task_execute {
	sudo -u "$redmine_user" -H ssh-keygen -t dsa -f "$ssh_key" -N ''
}
export -f task_execute