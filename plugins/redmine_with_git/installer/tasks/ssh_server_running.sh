#!/bin/bash

set -u
set -e

function task_condition {
  programeiro /linux/service_running "$SSH_SERVER_SERVICE"
}

function task_dependencies {
  echo ssh_server
}

function task_fix {
  sudo service "$SSH_SERVER_SERVICE" start
}
