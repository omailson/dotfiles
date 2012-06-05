_sssh_comp() {
	local cur prev anteprev opts hosts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	anteprev="${COMP_WORDS[COMP_CWORD-2]}"

	opts="-i -x -l -h --help"
	hosts=$(sssh -l | cut -d ' ' -f 1)

	case "${prev}" in
		-i)
			echo
			;;
		-x)
			COMPREPLY=($(compgen -W "${hosts}" -- ${cur}))
			return 0
			;;
		*)
			;;
	esac

	if [ "${prev}" = "-x" ]
	then
		COMPREPLY=($(compgen -W "${hosts}" -- ${cur}))
		return 0
	fi

	if [ "${anteprev}" = "-i" ]
	then
		COMPREPLY=($(compgen -A hostname -- ${cur}))
		return 0
	fi

	COMPREPLY=($(compgen -W "${hosts} ${opts}" -- ${cur}))
	return 0
}

_goto_comp() {
	local folders gotopath cur
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"

	folders=$(echo $GOTOFOLDERS | tr "," '\n' | cut -d : -f 1)

	gotopath="$PWD"
	while [ 1 ]
	do
		if [ -e "$gotopath"/.goto ]
		then
			folders="$folders"$'\n'$(cat "$gotopath"/.goto | cut -d : -f 1)
		fi

		test "$gotopath" = $HOME -o "$gotopath" = "/" && break

		gotopath=$(readlink -f "$gotopath"/..)
	done

	COMPREPLY=($(compgen -W "${folders}" -- ${cur}))
	return 0
}

_changemac_comp() {
	local cur macs
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"

	macs=$(changemac | cut -d ' ' -f 1)
	COMPREPLY=($(compgen -W "$macs" -- ${cur}))
	return 0
}

complete -F _sssh_comp sssh
complete -F _goto_comp goto
complete -F _changemac_comp changemac
