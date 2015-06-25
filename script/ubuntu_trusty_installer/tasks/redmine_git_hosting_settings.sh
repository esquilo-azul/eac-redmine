#!/bin/bash

set -u
set -e

function psql_execute {
	set -u
	set -e
	PGPASSWORD="$postgresql_password" psql -h 'localhost' -U "$postgresql_user" -tAc "$1" "$postgresql_database"
}

function settingValue {
	psql_execute "select value from settings where name='$1'"	
}

function settingSetted {	
	TEST=$(psql_execute "select 1 from settings where name='$1'")
	if [ -n "$TEST" -a "$TEST" == '1' ]; then
		return 0
	else
		return 1
	fi
}

function createSetting {
	psql_execute 'insert into settings(name,value,updated_on) values ('\'"$1"\'', '\'"$2"\'', current_timestamp)'
}

function updateSetting {	
	psql_execute 'update settings set value='\'"$2"\'', updated_on=current_timestamp where name='\'"$1"\'
}

function task_dependencies {
	echo redmine_database_schema
}

export -f task_dependencies

function task_condition {
	local temp=$(mktemp)
	settingValue 'plugin_redmine_git_hosting' > "$temp"
	result=$("$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_git_hosting_setting_value.sql" | "$INSTALL_ROOT/lib/text/diff-stdin-file.sh" "$temp" )
	rm -f "$temp"
	return $result
}
export -f task_condition

function task_execute {
	set -u
	set -e
	
	local setting_name='plugin_redmine_git_hosting'
	local setting_value=$("$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_git_hosting_setting_value.sql" | "$INSTALL_ROOT/lib/text/escape_single_quotes.sh")
	if settingSetted "$setting_name"; then
		updateSetting "$setting_name" "$setting_value"
	else
		createSetting "$setting_name" "$setting_value"
	fi
}
export -f task_execute