# Shell environments manager
# Author: Mailson Menezes <mailson@gmail.com>
#
# Source this file to start using it
#
# $ environment 
# will source the environment file in the current directory (if existis)
#
# $ environment name
# will source the 'name' environment
#
# $ environment name --link
# create symbolic links to all files in 'name' environment

export ENVIRONMENT_FOLDER="$DOTFILES_PATH"/environments

environment() {
	if [ "$#" -eq 0 ]
	then
		if [ -e bashrc ]
		then
			source bashrc
		else
			echo "Can't find environment file"
			return 1
		fi
	else
		if [ -d "$ENVIRONMENT_FOLDER/$1" ]
		then
			if [ -n "$2" -a "$2" = "--link" ]
			then
				ln -s "$ENVIRONMENT_FOLDER/$1"/* .
			else
				source "$ENVIRONMENT_FOLDER/$1/bashrc"
			fi
		else
			echo "Invalid environment"
			return 1
		fi
	fi

	return 0
}

# Autocomplete function to list all available environments
function _environment_comp () {
	local cur
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	local envs=$(for folder in "$ENVIRONMENT_FOLDER"/*; do if [ -d "$folder" ]; then basename "$folder"; fi; done)
	COMPREPLY=($(compgen -W "${envs}" -- ${cur}))
	return 0
}

complete -F _environment_comp environment

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
