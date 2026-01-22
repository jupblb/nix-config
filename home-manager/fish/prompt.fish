#!/usr/bin/env fish

set -l cmd_status $status

# hostname
if set -q SSH_TTY
    echo -n "$(set_color 98971a)$(prompt_hostname):$(set_color normal)"
end

# pwd
set -l path (prompt_pwd)
if test -n "$DIRENV_FILE"
    set -l base (dirname "$DIRENV_FILE")
    if string match -q "$base*" $PWD
        set -l suffix (string replace "$base" "" $PWD)
        set path "…"(test -n "$suffix" && echo $suffix || echo /)
    end
end
echo -n "$(set_color 79740e)$path$(set_color normal) "

# sign
if test $fish_bind_mode = insert
    echo -n "$(set_color --bold)"
else
    echo -n "$(set_color --dim)"
end

if test $cmd_status -gt 0
    echo -n "$(set_color --underline 9d0006)"
else if jobs -q
    echo -n "$(set_color b57614)"
else
    echo -n "$(set_color 79740e)"
end
echo -n "~>$(set_color normal) "
