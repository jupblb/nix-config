#!/bin/sh
# https://github.com/gokcehan/lf/wiki/Integrations#fzf

res="$(fd . --type "$1" 2>/dev/null | fzf --reverse | sed 's/\\/\\\\/g;s/"/\\"/g')"
if [ -d "$res" ]; then
    cmd="cd"
elif [ -f "$res" ]; then
    cmd="select"
else
    exit 0
fi

lf -remote "send $id $cmd \"$res\""
