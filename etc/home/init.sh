#!/bin/bash

# Initialize those configuration files
# Example: ./init.sh gitconfig
# Will create a symlink to this 'gitconfig' at ~/.gitconfig

DESTINATION_PATH=$HOME

configure() {
	# Check if a files, directory, link, etc already exists
	if [ -e "$DESTINATION_PATH/$2" ]
	then
		echo "Cannot write to $DESTINATION_PATH/$2"
		exit 1
	fi

	ln -s "$PWD/$1" "$DESTINATION_PATH/$2"
	echo "Successfully linked $DESTINATION_PATH/$2 to $PWD/$1"
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
		exit 1
		;;
esac
