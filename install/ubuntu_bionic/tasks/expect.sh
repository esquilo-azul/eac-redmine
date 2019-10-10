#!/bin/bash

set -u
set -e

function task_condition {
  programeiro /apt/installed expect
}

function task_fix {
  programeiro /apt/assert_installed expect
}
