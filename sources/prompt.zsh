# Enable prompt substitution so that command substitutions are re-evaluated every time the prompt is drawn.
setopt PROMPT_SUBST

__CK() {
  # Use %s to prevent printf from misinterpreting backslashes.
  printf "\033[$1m%s\033[m" "$2"
}

__align_to_right() {
  # TODO: Handle the case when length($1) > $COLUMNS
  local pos=$(( COLUMNS - ${#1} + 1 ))
  printf "\033[s\033[${pos}G$1\033[u"
}

# Returns the workspace subfolder, if any. Optionally, override by defining __workspace_suffix_custom.
__workspace_suffix() {
  if ! __workspace_suffix_custom "$1" 2>/dev/null; then
    local git_prefix
    git_prefix=$(git rev-parse --show-prefix 2>/dev/null)
    git_prefix=${git_prefix%/}
    printf "%s" "$git_prefix"
  fi
}

# Prints a path using one color for the prefix and another for the suffix.
__format_folder_info() {
  local workspace_suffix=$(__workspace_suffix "$1")
  __CK "1;34" ${1%$workspace_suffix}
  __CK "35" "$workspace_suffix"
}

# Repeats a given string N times.
# Usage: __repeat N string
__repeat() {
  local repeat_line=""
  for i in $(seq "$1"); do
    repeat_line="${repeat_line}$2"
  done
  printf "%s" "$repeat_line"
}

# Select a separator character based on terminal encoding.
if [ "$(locale charmap)" = "UTF-8" ]; then
  PS1_SEP="─"
else
  PS1_SEP="-"
fi

# Check for iTerm2 integration.
if [[ "$TERM_PROGRAM" = "iTerm.app" ]]; then
  PS1_ITERM2_PROMPT_MARK='%{$(iterm2_prompt_mark)%}'
else
  PS1_ITERM2_PROMPT_MARK=''
fi

# Build prompt components.
# Zsh requires nonprinting sequences to be wrapped in %{…%} for proper length calculation.
PS1_SEPARATOR="%(?.%F{white}.%F{red})$(__repeat ${COLUMNS:-3} ${PS1_SEP})%f"
PS1_USERINFO="%F{green}%n%B%F{white}@%b%F{green}%m%f"
PS1_FOLDERINFO='$(__format_folder_info $PWD)'
PS1_GIT="%{$(__CK '1;37' "$(__git_ps1 ' (%s)' 2>/dev/null)")%}"
PS1_ENV='%B%F{white}$(__environment_name " [%s]")%b%f'
# PS1_VENV="%{$(__CK '1;32' "$(__venv_name ' {%s}')")%}"
PS1_VENV=""
PS1_JOBS="%(1j.%F{red}+%j%f.)"
PS1_INPUT="%{%B%F{green}%}%#%{%f%b%}"
PS1_RIGHT_ALIGNED="%{$(__align_to_right '')%}"

PS1="${PS1_SEPARATOR}"$'\n'"${PS1_USERINFO} ${PS1_FOLDERINFO}${PS1_GIT}${PS1_ENV}${PS1_VENV}${PS1_RIGHT_ALIGNED}"$'\n'"${PS1_ITERM2_PROMPT_MARK}${PS1_INPUT}${PS1_JOBS} "