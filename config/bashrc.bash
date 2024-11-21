#!/usr/bin/env bash

if [[ "$SHLVL" -eq "1" && -n "$SSH_TTY" && -x "$(command -v fish)" ]]; then
    SHELL=$(which fish)
    export SHELL
    exec fish
fi

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"
