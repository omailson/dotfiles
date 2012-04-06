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

complete -F _sssh_comp sssh
