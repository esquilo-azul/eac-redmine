#!/bin/bash

set -u
set -e

function task_dependencies {
	echo rvm
}
export -f task_dependencies

function task_condition {
	if [ ! -f ~/.rvm/rubies/$rvm_ruby/bin/ruby ]; then
		return 1
	fi
}
export -f task_condition

function task_execute {
	rvm install $rvm_ruby
}
export -f task_execute

