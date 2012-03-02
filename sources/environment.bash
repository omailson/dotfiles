function activate() {
	if [ -e bashrc ]
	then
		source bashrc
	fi
}

function __environment_name() {
	if [ -n "$ENV_NAME" ]
	then
		printf -- "$1" "$ENV_NAME"
	elif [ -e bashrc ]
	then
		printf -- "$1" "*"
	else
		printf -- ""
	fi
}
