#!/bin/bash

set -u
set -e

function task_dependencies {
	echo redmine_database_schema redmine_apache_site redmine_public_link redmine_git_hosting redmine_enabled_scm_setting redmine_host_name_setting
}
export -f task_dependencies