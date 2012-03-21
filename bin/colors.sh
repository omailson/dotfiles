#!/bin/bash
# colors.sh
# Show available colors for console
#
# Author: Aurélio Marinho Jargas (aurelio.net)

for foreground in 0 1 2 3 4 5 6 7; do
	for strong in '' ';1'; do
		for background in 0 1 2 3 4 5 6 7; do
			seq="4$background;3$foreground"
			echo -e "\033[$seq${strong}m\c"
			echo -e " $seq${strong:-  } \c"
			echo -e "\033[m\c"
		done; echo
	done
done
