#!/bin/zsh

CONF_STATUS=0
INSTALL_COMMAND="source $PWD/dotfilesrc"

NO_LOCAL_RC=0
DOTFILES_SHELL=""
AUTO_INSTALL=0

while [ -n "${1:-}" ]; do
  case "$1" in
    --no-local-rc) NO_LOCAL_RC=1; shift;;
    --auto-install) AUTO_INSTALL=1; shift;;
    *) break;;
  esac
done

# Initial check: ensure you're inside the dotfiles folder.
if [ ! -f dotfilesrc ]; then
    print -P "%B%F{red}You must execute this script inside the dotfiles folder%f%b"
    exit 1
fi

# Check for the local configuration file.
if [ "$NO_LOCAL_RC" -eq 0 ] && [ ! -f local.zshrc ]; then
    print -P "%B%F{red}Please, create a file named local.zshrc based on local.zshrc.template%f%b"
    exit 1
fi

# Load the yes/no prompt function.
source sources/ask.sh

rcfile="$HOME/.zshrc"


# If DOTFILES_PATH is not set, suggest adding the installation command.
if [ -z "$DOTFILES_PATH" ]; then
    echo "You should add the following line to your main $rcfile"
    echo "$INSTALL_COMMAND"
    if [ $AUTO_INSTALL -eq 1 ]; then
        echo "" >> "$rcfile"
        echo "# My dotfiles" >> "$rcfile"
        echo "$INSTALL_COMMAND" >> "$rcfile"
    elif ask "Do you want me to add it for you?" Y; then
        echo "" >> "$rcfile"
        echo "# My dotfiles" >> "$rcfile"
        echo "$INSTALL_COMMAND" >> "$rcfile"
    else
        CONF_STATUS=1
    fi
fi

echo "Updating submodules..."
git submodule update --init

if [ "$?" -ne 0 ]
then
    print -P "%B%F{red}Failed to update submodules%f%b"
    exit 1
fi

# Final message if configuration completed without issues.
if [ "$CONF_STATUS" -eq 0 ] && [ -z "$DOTFILES_PATH" ]; then
    echo "Configuration ended successfully. Type the following command to start using now:"
    echo "$INSTALL_COMMAND"
fi

exit "$CONF_STATUS"