export VIRTUAL_ENV_DISABLE_PROMPT="yes"

__venv_name() {
  local project_name

  # Only replace the (env) in PS1 if we disable virtualenv from doing so
  # Also, check whether the venv is activated
  if [[ -n "$VIRTUAL_ENV_DISABLE_PROMPT" && -n "$VIRTUAL_ENV" ]]; then
    project_name=$(basename "$VIRTUAL_ENV")
    printf "$1" "venv:$project_name"
  else
    printf ""
  fi
}
