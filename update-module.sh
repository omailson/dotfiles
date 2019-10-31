#!/bin/bash

## Helper script to update a module
## Usage: ./update-module.sh module_name
## ls modules/ # to list all module names

set -e

MODULE_NAME="$1"

if [ -z "$MODULE_NAME" ]
then
	echo "You need to provide a module name"
	echo "To update all submodules, use: git submodule --foreach git pull"
	exit 1
fi

MODULE_FOLDER="modules/$MODULE_NAME"
if [ ! -d "$MODULE_FOLDER" ]
then
	echo "Module not found. Please check the name and make sure you're in the dotfiles folder"
	exit 1
fi

pushd "$MODULE_FOLDER"
git pull
popd

git add "$MODULE_FOLDER"

set +e

# TODO properly check if anything have changed
if git commit -m "Update module $MODULE_NAME"
then
	echo "Module updated. Please, push your changes"
else
	# TODO supress status message when failed
	echo "Nothing to update"
fi

