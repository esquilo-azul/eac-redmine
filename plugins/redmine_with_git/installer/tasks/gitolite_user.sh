#!/bin/bash

set -u
set -e

function task_condition {
  id -u "$gitolite_user" >/dev/null 2>&1
}

function task_fix {
  sudo useradd --system "$gitolite_user"
}
