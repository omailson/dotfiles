#!/bin/bash
# Script to perform a remote backup of the current git workspace

gitbackup_untracked_files=$(git ls-files --others --directory)
for f in $gitbackup_untracked_files
do
	read -p "Add untracked file? $f [Y/n] "
	if [ "$REPLY" = "y" -o -z "$REPLY" ]
	then
		git add $f
	fi
done
unset gitbackup_untracked_files

git commit -a -m WIP
git push -f origin HEAD:backup-"$USER"
git reset HEAD~1
