#!/bin/bash

set -u
set -e

function task_condition {
  programeiro /rails/bundle config get build.rugged --parseable | grep -qF -- '--with-ssh'
}

function task_fix {
  programeiro /rails/bundle config set build.rugged --with-ssh
}
