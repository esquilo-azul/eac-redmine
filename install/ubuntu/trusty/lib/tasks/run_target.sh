#!/bin/bash

set -e
set -u

export CHECKED_TASKS=''
export TRIGGERS=''

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
	if [ $("$INSTALL_ROOT/lib/text/valid_check_name.sh" "$task") -ne 0 ]; then
		echo "Invalid task name: \"$task\""
		exit 1
	fi
	if [ $("$INSTALL_ROOT/lib/text/checked.sh" "$CHECKED_TASKS" "$1") -ne 0 ]; then
		CHECKED_TASKS=$("$INSTALL_ROOT/lib/text/check.sh" "$CHECKED_TASKS" "$1")
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
				for trigger in $(_call_task_function $task task_triggers); do
					TRIGGERS=$("$INSTALL_ROOT/lib/text/check.sh" "$TRIGGERS" "$trigger")	
				done
			fi
		else		
			_task_message_condition $task 1 0
		fi
	fi
}

function run_triggers {
	echo '-------------------------------------------'
	echo "Triggers: \"$TRIGGERS\""
	if [ -n "$TRIGGERS" ]; then
		IFS='|' read -ra triggers <<< "$TRIGGERS"
		for trigger in "${triggers[@]}"; do
			echo "Executando trigger \"$trigger\"..."
			'trigger_'$trigger
		done
	fi
}

export -f check_task
check_task $1
run_triggers