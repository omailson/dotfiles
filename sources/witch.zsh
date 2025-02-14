witch() {
	# Fail with usage information
	if [[ $# -ne 1 || $1 == "--help" || $1 == "-h" ]]
	then
		echo "Usage: witch <program>" >&2
		return 1
	fi

	# Show error when passed argument is not a valid command
	local type_info
	type_info=$(whence -v "$1")
	if [[ -z "$type_info" ]]
	then
		echo "$1: command not found" >&2
		return 1
	fi

	# If the command is a shell function, builtin, or alias, assume it's not a file.
	if [[ "$type_info" =~ "shell function" || "$type_info" =~ "builtin" || "$type_info" =~ "alias" ]]
	then
		echo "$type_info"
	else
		# Otherwise, assume it’s a file.
		local WHICH FILE_DATA
		WHICH=$(which "$1")
		FILE_DATA=$(file "$WHICH")
		echo "$FILE_DATA"
		if echo "$FILE_DATA" | grep -q 'ASCII text executable$'
		then
			if [[ -n "$EDITOR" ]]
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

# TODO treat case when there are multiple types (eg: `type -a cerberus` gives an alias and a file (try `type -ta cerberus`))
#      we need to decide what to do when there are multiple types. specially when it's a function or a text file
