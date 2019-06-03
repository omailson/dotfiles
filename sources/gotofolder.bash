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

realpath() {
	if readlink -f 2>/dev/null
	then
		readlink -f "$1"
	else
		realpath.py "$1"
	fi
}

goto() {
	local folders foldername folderpath gotopath folder
	folders=$(echo $GOTOFOLDERS | tr "," '\n')

	gotopath="$PWD"
	while [ 1 ]
	do
		if [ -e "$gotopath"/.goto ]
		then
			folders="$folders"$'\n'$(paste -d : <(cat "$gotopath"/.goto | cut -d : -f 1) <(cat "$gotopath"/.goto | cut -d : -f 2 | xargs -I {} realpath "$gotopath"/{}))
		fi

		test "$gotopath" = $HOME -o "$gotopath" = "/" && break

		gotopath=$(realpath "$gotopath"/..)
	done

	for folder in $folders
	do
		foldername=$(echo $folder | cut -d : -f 1)
		folderpath=$(echo $folder | cut -d : -f 2)

		if [ "$1" == "$foldername" ]
		then
			cd $(realpath "$folderpath")
			pwd
			break
		fi
	done
}

export -f goto
