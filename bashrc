#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

PS1="\[\e[0;32m\]\u@\h \[\e[39m\]\[\e[0;37m\]\w\[\e[39m\]\[\e[0;34m\] →\[\e[34;1m\] \[\e[39m\] \[\e[0m\]";

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"
# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"
# Useful timestamp format
HISTTIMEFORMAT='%F %T '

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'} history -a; history -c; history -r"

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Save multi-line commands as one command
shopt -s cmdhist

# Update window size after each command
shopt -s checkwinsize

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

