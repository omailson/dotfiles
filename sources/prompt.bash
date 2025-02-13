# Changes text color and then reset color changes
function __CK() {
	printf "\033[$1m$2\033[m"
}

function __align_to_right() {
	# TODO check when len($1) > $COLUMNS
	local pos=$(($COLUMNS - ${#1} + 1))
	printf "\033[s\033[${pos}G$1\033[u"
}

# Returns the subfolder of the workspace (if any)
#
# Alternatevely, you can implement your own __workspace_suffix_custom if you
# want to override the default behavior
#
# Custom function may fallback to default behavior if it returns non-zero
# eg: Workspace: /path/to/project
#     CWD: /path/to/project/libs
#     Returns: libs
function __workspace_suffix() {
	if ! __workspace_suffix_custom "$1" 2> /dev/null
	then
		# Neat trick. This default behavior will only execute if the custom function doesn't exist, or if it returns non-zero
		# This makes the custom function optional and gives it the possibility to fallback to default behavior if needed.
		local git_prefix=$(git rev-parse --show-prefix 2>/dev/null)
		git_prefix=${git_prefix%/}

		printf "$git_prefix"
	fi
}

# Given a path, print it using different colors for the prefix and suffix
# This is useful to differentiate whether you are in the root of a project or in one of its subfolders
function __format_folder_info() {
	local workspace_suffix=$(__workspace_suffix "$1") # Check what part of the path is the suffix
	__CK "1;34" "${1%$workspace_suffix}" # Print the path, excluding its suffix
	__CK "35" "$workspace_suffix" # Print the path suffix (in a different color from the normal path)
}

# Repeats a given string N times
# Use: __repeat N string
function __repeat() {
	for i in $(seq $1)
	do
		repeat_line="$repeat_line$2"
	done

	printf -- $repeat_line
}

function __status_color() {
	if [ $? -eq 0 ]
	then
		printf -- "0;37"
	else
		printf -- "0;31"
	fi
}

function __dotfiles_jobs() {
	if [ "$1" -gt 0 ]
	then
		printf -- "+$1"
	fi
}

if [ "$(locale charmap)" = "UTF-8" ]
then
    PS1_SEP="─"
else
    PS1_SEP="-"
fi

# Check for iTerm integration
if [ "$TERM_PROGRAM" = "iTerm.app" ]
then
	# Add iterm2 prompt mark (https://www.iterm2.com/documentation-shell-integration.html)
	PS1_ITERM2_PROMPT_MARK='\[$(iterm2_prompt_mark)\]'
else
	PS1_ITERM2_PROMPT_MARK=''
fi

PS1_SEPARATOR='$(__CK "$(__status_color)" "$(__repeat ${COLUMNS:-3} ${PS1_SEP})")'
PS1_USERINFO='$(__CK "0;32" "\u")$(__CK "1;37" "@")$(__CK "0;32" "\h")'
PS1_FOLDERINFO='$(__format_folder_info "\w")'
PS1_GIT='$(__CK "1;37" "$(__git_ps1 " (%s)" 2> /dev/null)")'
PS1_ENV='$(__CK "1;37" "$(__environment_name " [%s]")")'
PS1_VENV='$(__CK "1;32" "$(__venv_name " {%s}")")'
PS1_JOBS='\[\e[31m\]$(__dotfiles_jobs "\j")\[\e[m\]'
PS1_INPUT='\[\e[1;32m\]\$\[\e[m\]' # Ctrl+A won't work on long lines if using __CK
PS1_RIGHT_ALIGNED='$(__align_to_right "")'
PS1="$PS1_SEPARATOR\n$PS1_USERINFO $PS1_FOLDERINFO$PS1_GIT$PS1_ENV$PS1_VENV$PS1_RIGHT_ALIGNED\n$PS1_ITERM2_PROMPT_MARK$PS1_INPUT$PS1_JOBS "

# TODO add a placeholder intead of \[$(iterm2_prompt_mark)\] (eg: %ITERM2_INTEGRATION%)
# TODO # source "$DOTFILES_PATH"/sources/iterm2_integration.bash (push with this line commented-out (?) maybe not necessary since iterm2_integration already checks if script exists)
# TODO the above script will simply replace the placeholder by \[$(iterm2_prompt_mark)\] and run the iterm2_integration command
# TODO set: PS1=without_placeholder($PS1) to remove the placeholder if it's still there