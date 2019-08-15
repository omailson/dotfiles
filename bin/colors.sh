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
			ret="$ret$1$sep"
		fi
		shift
	done

	printf -- "${ret%;}"
}

function __colors_colorized() {
	echo -e "\033[${1}m\c"
	echo -n "$2"
	echo -e "\033[m\c"
}

function __colors_usage() {
	local cmd escape
	cmd="$1"
	escape="$2"

	echo $'\t'$(__colors_colorized 34 "$cmd \"")$(__colors_colorized 33 "$escape[")$(__colors_colorized 1 "<color>")$(__colors_colorized 33 "m")$(__colors_colorized 34 "<string>")$(__colors_colorized 33 "$escape[m")$(__colors_colorized 34 "\"")
}

for foreground in '' '30' '31' '32' '33' '34' '35' '36' '37'; do
	for strong in '' '1'; do
		for background in '' '40' '41' '42' '43' '44' '45' '46' '47'; do

			seq=$(__colors_join ';' "$background" "$foreground" "$strong")
			echo -e "\033[${seq}m\c"
			printf ' %-7s ' "$seq"
			echo -e "\033[m\c"
		done; echo
	done
done

echo
echo $(__colors_colorized "1" "Usage:")
__colors_usage "echo -e" "\033"
__colors_usage "printf" "\e"
