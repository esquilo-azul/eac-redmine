#!/bin/bash

set -u
set -e

function task_dependencies {
  echo development redmine_as_apache_path redmine_public_link
}
export -f task_dependencies
