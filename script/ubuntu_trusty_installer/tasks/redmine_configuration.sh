#!/bin/bash

set -u
set -e

function task_condition {
	return $("$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_configuration.yml" | "$INSTALL_ROOT/lib/text/diff-stdin-file.sh" "$REDMINE_ROOT/config/configuration.yml" )	
}
export -f task_condition

function task_execute {
	"$INSTALL_ROOT/lib/text/template.sh" "$INSTALL_ROOT/template/redmine_configuration.yml" > "$REDMINE_ROOT/config/configuration.yml"
}
export -f task_execute