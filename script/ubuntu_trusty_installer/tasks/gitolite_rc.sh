#!/bin/bash

set -u
set -e

gitolite_rc_file="$gitolite_user_home/.gitolite.rc"

function gitolite_rc_template {
	"$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/gitolite.rc"	
}

function task_dependencies {
	echo gitolite_setup
}
export -f task_dependencies

function task_condition {
	if [ "$(gitolite_rc_template | "$INSTALL_ROOT/lib/text/diff-stdin-file.sh" "$gitolite_user_home/.gitolite.rc" )" -ne 0 ]; then
		return 1
	fi 	
}
export -f task_condition

function task_execute {
	gitolite_rc_template | sudo -u "$gitolite_user" tee "$gitolite_user_home/.gitolite.rc" > /dev/null 
}
export -f task_execute

function task_triggers {
	echo redmine_git_hosting_rescue
}
export f task_triggers
