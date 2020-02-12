#!/bin/bash

## IMPORT ask() FUNCTION
if [ -z "$DOTFILES_PATH" ]
then
	echo "This script requires github.com/omailson/dotfiles"
	exit 1
fi

source "$DOTFILES_PATH"/sources/ask.sh
## END OF IMPORT ask() FUNCTION


## CONSTANTS
ROOT_BOOKMARK_PLACE="$HOME"
## END OF CONSTANTS


## FUNCTIONS
function find_closest_bookmark_place() {
	local previous_place current_place

	previous_place=""
	current_place="$PWD"
	while [ "$previous_place" != "$current_place" ]
	do
		if [ -e "$current_place"/.goto ]
		then
			echo "$current_place"
			return 0
		fi

		cd ..
		previous_place="$current_place"
		current_place="$PWD"
	done

	return 1
}

function show_help() {
	cat << EOF
$(basename $0) -a <bookmark_name> [bookmark_location]
	Create a bookmark with a given name to the current folder

	bookmark_name
		The name of the bookmark
	bookmark_location
		To which .goto file the bookmark will be added (default $DEFAULT_BOOKMARK_PLACE)

	Options
		-a
			Auto-detect a name for the bookmark based on the current folder name
EOF
}

function show_error() {
	echo -e "\033[31m$1\033[m" >&2
	exit 1
}
## END OF FUNCTIONS


## INITIALIZATION
DEFAULT_BOOKMARK_PLACE="$ROOT_BOOKMARK_PLACE"
CLOSEST_BOOKMARK_PLACE=$(find_closest_bookmark_place)
if [ "$?" -eq 0 ]
then
	DEFAULT_BOOKMARK_PLACE="$CLOSEST_BOOKMARK_PLACE"
fi
## END OF INITIALIZATION


## ARGUMENTS PARSING
# Options parser
case "$1" in
	-h|--help)
		show_help
		exit 0
		;;
	-a|--auto)
		# Auto-detect folder name removing special charaters not allowed in goto-folder
		BOOKMARK_NAME=$(basename "$PWD" | tr -cd '[:alnum:]_-')
		if [ "$#" -gt 2 ]
		then
			show_help
			show_error "Too many arguments. You don't have to pass a bookmark name when using -a"
		fi
		;;
	*)
		BOOKMARK_NAME="$1"
		;;
esac

# Set $BOOKMARK_PLACE (if given, otherwise use default)
if [ -n "$2" ]
then
	BOOKMARK_PLACE="$2"
else
	BOOKMARK_PLACE="$DEFAULT_BOOKMARK_PLACE"
fi
## END OF ARGUMENTS PARSING


## VALIDATIONS
# Check if $BOOKMARK_NAME is valid
if [ -z "$BOOKMARK_NAME" ]
then
	show_help
	show_error "A name for the bookmark is required"
fi

# Check if $BOOKMARK_PLACE is a directory
if [ ! -d "$BOOKMARK_PLACE" ]
then
	show_error "$BOOKMARK_PLACE is not a valid directory"
fi
## END OF VALIDATIONS

GOTO_FILE="$BOOKMARK_PLACE"/.goto
echo -e "Will create a bookmark called \033[1m$BOOKMARK_NAME\033[m pointing to \033[1m$PWD\033[m in \033[1m$GOTO_FILE\033[m"
if ask "Do you wish to continue?" Y
then
	echo "$BOOKMARK_NAME:$PWD" >> "$GOTO_FILE"
	if [ "$?" -eq 0 ]
	then
		echo "Bookmark successfully created"
	else
		show_error "Failed to create a bookmark"
	fi
fi
