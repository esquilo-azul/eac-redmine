#!/bin/bash

set -u
set -e

function task_condition {
	return $("$INSTALL_ROOT/lib/apt/installed.sh" libcurl4-openssl-dev libssl-dev apache2-dev libapr1-dev libaprutil1-dev)	
}
export -f task_condition

function task_execute {
	sudo apt-get install -y libcurl4-openssl-dev libssl-dev apache2-dev libapr1-dev libaprutil1-dev
}
export -f task_execute