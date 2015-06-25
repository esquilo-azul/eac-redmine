#!/bin/bash

DIR=$(echo ~/.rvm/gems/*/gems/passenger-*)	
if [ -d "$DIR" ]; then
	echo $DIR
else
	echo ''
fi