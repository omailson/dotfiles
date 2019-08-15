witch() {
	# Fail with usage information
	if [ "$#" -ne 1 -o "$1" == "--help" -o "$1" == "-h" ]
	then
		echo "Usage: witch <program>" >&2
		return 1
	fi

	# Show error when passed argument is not a valid command
	TYPE=$(type -t "$1")
	if [ "$?" -ne 0 ]
	then
		echo "$1: command not found" >&2
		return 1
	fi

	# If not a file, display what information we have about the command
	if [ "$TYPE" != "file" ]
	then
		type "$1"
	else
		# If it's a file, display more information about it and open if it's a text file
		WHICH=$(which "$1")
		FILE_DATA=$(file "$WHICH")
		echo "$FILE_DATA"
		if echo "$FILE_DATA" | grep -q 'text$'
		then
			if [ -n "$EDITOR" ]
			then
				if ask "$1 is a text file. Open in $EDITOR?" Y
				then
					$EDITOR "$WHICH"
				fi
			else
				echo "$1 is a text file but no \$EDITOR is set"
			fi
		fi
	fi
}
