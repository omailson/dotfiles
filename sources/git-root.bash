function gitroot() {
	local top_level return_code

	top_level=$(git-root.sh "$@")
	return_code="$?"
	if [ "$return_code" -eq 0 ]
	then
		cd "$top_level"
	fi

	return "$return_code"
}
