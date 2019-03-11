#!/bin/bash

set -u
set -e

"$INSTALL_ROOT/lib/rails/rake.sh" secret 2> /dev/null
