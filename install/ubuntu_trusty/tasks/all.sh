#!/bin/bash

set -u
set -e

function task_dependencies {
  echo development redmine_apache_site redmine_public_link
}
export -f task_dependencies
