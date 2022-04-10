#!/bin/bash

set -u
set -e

if bool_r "$SKIP_DATABASE"; then exit 0; fi

programeiro /rails/rake redmine_with_git:rescue
