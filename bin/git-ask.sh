#!/bin/bash

## IMPORT ask() FUNCTION
if [ -z "$DOTFILES_PATH" ]
then
	echo 2> "This script requires github.com/omailson/dotfiles"
	exit 1
fi

source "$DOTFILES_PATH"/sources/ask.sh
## END OF IMPORT ask() FUNCTION

# Print current HEAD
echo "Current HEAD is:"
git show --oneline --no-patch
echo

GA_PRINT_STATUS="Just print status"
GA_NEW_COMMIT="Create new commit"
GA_AMEND_COMMIT="Amend to existing commit"
GA_WIP_COMMIT="Create WIP commit"

PS3="What to do next? "

select OPTION in "$GA_PRINT_STATUS" "$GA_NEW_COMMIT" "$GA_AMEND_COMMIT" "$GA_WIP_COMMIT"
do
	case $OPTION in
		$GA_NEW_COMMIT)
			if ask "Create diff afterwards?" N
			then
				git commit
				arc diff HEAD~1 --allow-untracked --nointeractive
			else
				git commit
			fi
			;;
		$GA_AMEND_COMMIT)
			if ask "Update diff afterwards?" N
			then
				git commit --amend --no-edit
				arc diff HEAD~1 --allow-untracked --nointeractive
			else
				git commit --amend --no-edit
			fi
			;;
		$GA_WIP_COMMIT)
			git commit -m WIP
			;;
		*)
			git status "${@}"
			;;
	esac

	break
done

