#!/usr/bin/env bash

if [[ "$SHLVL" -eq "1" && -n "$SSH_TTY" && -x "$(command -v fish)" ]]; then
    SHELL=$(which fish)
    export SHELL
    exec fish
fi

export PS1="\[\e[0;32m\]\u@\h \[\e[0;37m\]\w\[\e[0;34m\] $ \[\e[0m\]"

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'} history -a; history -c; history -r"

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"
