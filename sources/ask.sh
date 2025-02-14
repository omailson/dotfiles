# This is a general-purpose function to ask Yes/No questions in Bash, either
# with or without a default answer. It keeps repeating the question until it
# gets a valid answer.
# http://djm.me/ask

ask() {
    local ask_prompt
    local ask_default

    while true; do

        if [ "${2:-}" = "Y" ]; then
            ask_prompt="Y/n"
            ask_default=Y
        elif [ "${2:-}" = "N" ]; then
            ask_prompt="y/N"
            ask_default=N
        else
            ask_prompt="y/n"
            ask_default=
        fi

        # Ask the question using /dev/tty to ensure input comes from the terminal.
        if [ -n "$ZSH_VERSION" ]; then
            read "REPLY?$1 [$ask_prompt] "
        else
            read -p "$1 [$ask_prompt] " REPLY </dev/tty
        fi

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$ask_default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}
