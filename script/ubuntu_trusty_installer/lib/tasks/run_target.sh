#!/bin/bash

set -e
set -u

export CHECKED_TASKS=''

function _task_checked {
	set +e	
	echo "$CHECKED_TASKS" | grep "$1|" > /dev/null
	local CHECKED=$?
	set -e
	echo $CHECKED
}
export -f _task_checked

function _mark_task_checked {
	CHECKED_TASKS="$CHECKED_TASKS""$1"'|'	
}
export -f _mark_task_checked

function _function_exists {
	set +e
	type $1 2> /dev/null > /dev/null
	RESULT=$?
	set -e
	echo $RESULT
}
export -f _function_exists

function _call_task_function {
	local task=$1
	local function_name=$2
	local script="$INSTALL_ROOT/tasks/$task.sh"
	unset -f $function_name
	if [ ! -f "$script" ]; then
		echo "Script for task \"$task\" does not exist"
		exit 1
	fi
	source "$script"
	if [ $(_function_exists $function_name) -eq 0 ]; then
		set +e
		$function_name
		local result=$?
		return $result
	else
		return 0
	fi
}
export _call_task_function

function _check_task_name {
	set -e
	set -u
	local task=$1
	set +e
	echo $task | grep '^[a-z]\+\(_[a-z]\+\)\{0,\}$' > /dev/null
	result=$?
	set -e
	if [ $result -ne 0 ]; then
		echo "Invalid task name: \"$task\""
		exit 1	
	fi
}
export _check_task_name

function _task_message {
	echo -e "\e[96m$1\e[0m$2" 	
}
export -f _task_message

function _task_message_condition {
	set -u
	set -e
	local task=$1
	local after=$2
	local result=$3
	local m=''
	if [ $after -eq 0 ]; then
		m="$m (AFTER): "
	else
		m="$m: "
	fi
	if [ $result -eq 0 ]; then
		m=$m'\e[92mok\e[0m'
	else
		m=$m'\e[91mnot ok\e[0m'
	fi	
	m="$m (\e[93m"
	local dependencies=$(_call_task_function $task task_dependencies)
	if [ -n "$dependencies" ]; then
		m="$m$dependencies"
	else
		m="$m-"
	fi
	m="$m\e[0m)"
	_task_message $task "$m"
}

function check_task {
	set -u
	set -e
	local task=$1
	_check_task_name "$task"
	if [ $(_task_checked "$task") -ne 0 ]; then
		_mark_task_checked "$task"
		for dep in $(_call_task_function $task task_dependencies); do
			check_task $dep
		done
		set +e
		_call_task_function $task task_condition
		local condition=$?
		if [ $condition -ne 0 ]; then
			_task_message_condition $task 1 1
			_call_task_function $task task_execute
			set +e
			_call_task_function $task task_condition
			local condition=$?
			if [ $condition -ne 0 ]; then
				_task_message_condition $task 0 1
				exit 1
			else
				_task_message_condition $task 0 0
			fi
		else		
			_task_message_condition $task 1 0
		fi
	fi
}
export -f check_task
check_task $1