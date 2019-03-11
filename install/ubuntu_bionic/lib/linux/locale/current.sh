#!/bin/bash

set -e
set -u

locale 2> /dev/null | sed 's/\(^.\+=\"\?\|\"$\)//g' | grep -v -e '^$' | sort | uniq
