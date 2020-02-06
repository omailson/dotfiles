#!/bin/bash
# Display repository's root directory
# Used in conjunction with gitroot function, which moves you to the repository's root

set -e

if [ "$1" != "--submodule" ] # --submodule bypasses the submodule check, so we can display submodule's root instead
then
	# Check whether we are in a submodule, and display superproject's root if so
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
