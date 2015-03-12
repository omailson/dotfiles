#!/bin/bash
# Script to perform a remote backup of the current git workspace

usage() {
cat << EOF
Perform remote backup of the current git workspace. If there are any untracked
file, it will be asked which ones the user wish to backup.

Usage: git backup [remote | --help]
EOF
}

gitbackup_remote="origin"
if [ "$#" -gt 0 ]
then
	if [ "$1" = "--help" ]
	then
		usage
		exit
	else
		gitbackup_remote="$1"
	fi
fi

if [ ! $(git remote | grep "$gitbackup_remote") ]
then
	echo "Couldn't find remote named $gitbackup_remote. Please use one of the following"
	git remote
	exit 1
fi

gitbackup_untracked_files=$(git ls-files --others --directory --exclude-standard)
if [ -n "$gitbackup_untracked_files" ]
then
	tmpfile=$(mktemp)

	# Insert information and untracked files to temp file
cat << EOF >> "$tmpfile"
# Showing untracked files to backup
# If there are any files you don't wish to save, you can simply remove the respective line
# Tracked files are not listed because they are supposed to be backed up
EOF
	echo "$gitbackup_untracked_files" >> "$tmpfile"

	# Open temp file with a text editor
	if [ -z "$EDITOR" ]
	then
		EDITOR=vim
	fi
	eval "$EDITOR" $tmpfile

	# Get selected files and stage them to commit
	gitbackup_untracked_files=$(cat "$tmpfile" | grep -v '^#')
	for f in $gitbackup_untracked_files
	do
		git add "$f"
	done

	# Remove temp file
	rm $tmpfile
fi

unset gitbackup_untracked_files

# Commit & push selected files
git commit -a -m WIP
git push -f "$gitbackup_remote" HEAD:backup-"$USER"
git reset HEAD~1
