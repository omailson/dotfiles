#!/bin/bash

set -e

CONF_STATUS=0
INSTALL_COMMAND="source $PWD/dotfilesrc"

# Initial check
if [ ! -f dotfilesrc ]
then
	echo "You must execute this script inside the dotfiles folder"
	exit 1
fi

if [ ! -f local.bashrc ]
then
	echo "Please, create a file named local.bashrc based on local.bashrc.template"
	CONF_STATUS=1
fi

# yes/no function
source sources/ask.sh

if [ -z "$DOTFILES_PATH" ]
then
	echo "You should add the following line to your main ~/.bashrc"
	echo "$INSTALL_COMMAND"
	if ask "Do you want me to add it for you?"
	then
		echo "" >> $HOME/.bashrc
		echo "# My dotfiles" >> $HOME/.bashrc
		echo "$INSTALL_COMMAND" >> $HOME/.bashrc
	else
		CONF_STATUS=1
	fi
fi

# Configure
if [ ! -L environments/python2/bin/python ]
then
	echo "Configuring python2 environment"
	mkdir -p environments/python2/bin/
	ln -s `which python2` environments/python2/bin/python
fi

echo "Updating submodules..."
git submodule update --init

if [ "$CONF_STATUS" -eq 0 -a -z "$DOTFILES_PATH" ]
then
	echo "Configuration ended successfully. Type the following command to start using now:"
	echo "$INSTALL_COMMAND"
fi

exit "$CONF_STATUS"
