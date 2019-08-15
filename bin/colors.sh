#!/bin/bash
# colors.sh
# Show available colors for console
#
# Author: Aurélio Marinho Jargas (aurelio.net)
# Author: Mailson Menezes

function __colors_join() {
	local ret sep

	sep="$1"
	shift

	while [ "$#" -gt 0 ]
	do
		if [ -n "$1" ]
		then
			# ret="$ret${1}${2:+$sep}"
			ret="$ret$1$sep"
		fi
		shift
	done

	printf -- "${ret%;}"
}

function __colors_ifnot() {
	if [ "$#" -ge 2 ]
	then
		if [ -z "$1" ]
		then
			printf -- "$2"
		fi
	fi
}

function __colors_colorized() {
	echo -e "\033[${1}m\c"
	echo -n "$2"
	echo -e "\033[m\c"
}

for foreground in '' '30' '31' '32' '33' '34' '35' '36' '37'; do
	foreground_pad=$(__colors_ifnot "$foreground" '   ')
	for strong in '' '1'; do
		strong_pad=$(__colors_ifnot "$strong" '  ')
		for background in '' '40' '41' '42' '43' '44' '45' '46' '47'; do
			background_pad=$(__colors_ifnot "$background" '   ')
			pad="$background_pad$foreground_pad$strong_pad"
			if [ -z "$foreground" -a -z "$strong" -a -z "$background" ]
			then
				pad="       "
			fi

			seq=$(__colors_join ';' "$background" "$foreground" "$strong")
			echo -e "\033[${seq}m\c"
			echo -e " $seq$pad \c"
			echo -e "\033[m\c"
		done; echo
	done
done

echo
echo $(__colors_colorized "1" "Usage:")
echo $'\t'$(__colors_colorized 34 "echo -e \"")$(__colors_colorized 33 "\033[")$(__colors_colorized 1 "<color>")$(__colors_colorized 33 "m")$(__colors_colorized 34 "<content>")$(__colors_colorized 33 "\033[m")$(__colors_colorized 34 "\"")
