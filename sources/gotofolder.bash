# goto folder - a bash script created by Mailson Lira
#
# CD to a folder faster. Just add the aliases to $GOTOFOLDERS variable
# Example: 
# export GOTOFOLDERS=small:/home/mailson/long/path,$GOTOFOLDERS
# Then type 'goto small' and you'll be there

function goto() {
	for folder in $(echo $GOTOFOLDERS | tr "," " ")
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
