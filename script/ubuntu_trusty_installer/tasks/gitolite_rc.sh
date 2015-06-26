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
	"$REDMINE_ROOT/bin/rake" redmine_git_hosting:install_hook_files
}
export -f task_execute
