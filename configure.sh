#!/bin/bash

CONF_STATUS=0

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

if [ -z "$DOTFILES_PATH" ]
then
	echo "Please, add the following line to your main ~/.bashrc"
	echo "source `pwd`/dotfilesrc"
	CONF_STATUS=1
fi

if [ ! -L environments/python2/bin/python ]
then
	echo "Configuring python2 environment"
	ln -s `which python2` environments/python2/bin/python
fi

exit "$CONF_STATUS"