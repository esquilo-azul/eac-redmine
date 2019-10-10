#!/bin/bash

set -u
set -e

function task_condition {
  programeiro /apt/installed ruby
}
export -f task_condition

function task_execute {
  programeiro /apt/assert_installed ruby
}
export -f task_execute
