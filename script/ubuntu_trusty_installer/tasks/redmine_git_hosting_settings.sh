#!/bin/bash

set -u
set -e



function task_dependencies {
	echo redmine_database_schema
}

export -f task_dependencies

function task_condition {
	local temp=$(mktemp)
	"$INSTALL_ROOT/lib/redmine/get_setting_value.sh" 'plugin_redmine_git_hosting' > "$temp"
	export redmine_git_hosting_ssh_key=$("$INSTALL_ROOT/lib/redmine_git_hosting/ssh_key.sh")
	return $("$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_git_hosting_setting_value.sql" | "$INSTALL_ROOT/lib/text/diff-stdin-file.sh" "$temp")
}
export -f task_condition

function task_execute {
	set -u
	set -e
	
	export redmine_git_hosting_ssh_key=$("$INSTALL_ROOT/lib/redmine_git_hosting/ssh_key.sh")
	local setting_value=$("$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_git_hosting_setting_value.sql" | "$INSTALL_ROOT/lib/text/escape_single_quotes.sh")
	"$INSTALL_ROOT/lib/redmine/set_setting_value.sh" 'plugin_redmine_git_hosting' "$setting_value"
}
export -f task_execute

function task_triggers {
	echo redmine_git_hosting_rescue
}
export f task_triggers