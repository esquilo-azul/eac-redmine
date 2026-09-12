#!/bin/bash

set -e
set -u

sudo ss -tlnp | awk '/"sshd"/ { port = $4; sub(/.*:/, "", port); print port; exit }'
