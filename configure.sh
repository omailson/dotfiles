#!/bin/sh

set -e

CONF_STATUS=0
INSTALL_COMMAND=". $PWD/dotfilesrc"

# Initial check: ensure you're inside the dotfiles folder.
if [ ! -f dotfilesrc ]; then
    echo "You must execute this script inside the dotfiles folder"
    exit 1
fi

# Check for the local configuration file.
if [ ! -f local.bashrc ]; then
    echo "Please, create a file named local.bashrc based on local.bashrc.template"
    CONF_STATUS=1
fi

# Load the yes/no prompt function.
. sources/ask.sh

# Determine which startup file to use based on the user's shell.
case "$SHELL" in
    */bash) rcfile="$HOME/.bashrc" ;;
    */zsh)  rcfile="$HOME/.zshrc" ;;
    *)      rcfile="$HOME/.profile" ;;
esac

# If DOTFILES_PATH is not set, suggest adding the installation command.
if [ -z "$DOTFILES_PATH" ]; then
    echo "You should add the following line to your main $rcfile"
    echo "$INSTALL_COMMAND"
    if ask "Do you want me to add it for you?"; then
        echo "" >> "$rcfile"
        echo "# My dotfiles" >> "$rcfile"
        echo "$INSTALL_COMMAND" >> "$rcfile"
    else
        CONF_STATUS=1
    fi
fi

# Configure python2 environment if not already set.
if [ ! -L environments/python2/bin/python ]; then
    echo "Configuring python2 environment"
    mkdir -p environments/python2/bin/
    PY2=$(command -v python2 || true)
    if [ -n "$PY2" ]; then
        ln -s "$PY2" environments/python2/bin/python
    else
        echo "python2 not found in PATH"
        CONF_STATUS=1
    fi
fi

echo "Updating submodules..."
git submodule update --init

# Final message if configuration completed without issues.
if [ "$CONF_STATUS" -eq 0 ] && [ -z "$DOTFILES_PATH" ]; then
    echo "Configuration ended successfully. Type the following command to start using now:"
    echo "$INSTALL_COMMAND"
fi

exit "$CONF_STATUS"