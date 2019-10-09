#!/bin/bash

set -e

if [ "$1" != "--submodule" ] # --submodule bypasses the submodule check, so we can go to submodule's root instead
then
	# First, check whether we are in a submodule and go to superproject's root if so
	SUPERPROJECT_WORKING_TREE=$(git rev-parse --show-superproject-working-tree)
	if [ -n "$SUPERPROJECT_WORKING_TREE" ]
	then
		echo "$SUPERPROJECT_WORKING_TREE"
		exit 0
	fi
fi

# Get the toplevel for the project or submodule
TOP_LEVEL=$(git rev-parse --show-toplevel)
if [ -z "$TOP_LEVEL" ]
then
	# This usuallly happens when we're inside a .git folder
	echo "Not in a git repository or in any of its submodules" >&2
	exit 1
fi

echo "$TOP_LEVEL"
