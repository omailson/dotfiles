# goto folder - a bash script created by Mailson Lira
#
# Change folders faster. Just add the aliases to $GOTOFOLDERS variable
# alias:path,anotheralias:anotherpath
#
# Example: 
# export GOTOFOLDERS=small:/home/mailson/long/path,$GOTOFOLDERS
# Then type 'goto small' and you'll be there
#
# You can also have a .goto on any folder to write local aliases
#
# Example:
# echo "alias:path/to/local/folder" >> .goto

function goto() {
	folders=""
	if [ -e .goto -a -e "$HOME"/.goto ]
	then
		folders=$(cat .goto "$HOME"/.goto)
	elif [ -e .goto ]
	then
		folders=$(cat .goto)
	elif [ -e "$HOME"/.goto ]
	then
		folders=$(cat "$HOME"/.goto)
	fi

	for folder in $folders
	do
		foldername=$(echo $folder | cut -d : -f 1)
		folderpath=$(echo $folder | cut -d : -f 2)

		if [ "$1" == "$foldername" ]
		then
			cd "$folderpath"
			pwd
			break
		fi
	done
}
