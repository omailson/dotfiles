#!/bin/bash

# Initialize those configuration files
# Example: ./init.sh gitconfig
# Will create a symlink to this 'gitconfig' at ~/.gitconfig

DESTINATION_PATH=$HOME

configure() {
	ln -s "$PWD/$1" "$DESTINATION_PATH/$2"
}

case "$1" in
	gitconfig|gitconfig_openbossa)
		configure "$1" .gitconfig
		;;
	inputrc)
		configure "$1" ."$1"
		;;
	ackrc)
		configure "$1" ."$1"
		;;
	*)
		echo "Unknown option"
		;;
esac
