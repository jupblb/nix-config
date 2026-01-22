#!/usr/bin/env fish

set -l cmd_status $status

# hostname
if set -q SSH_TTY
    echo -n "$(set_color 98971a)$(prompt_hostname):$(set_color normal)"
end

# pwd
if set -l prefix (git rev-parse --show-prefix 2>/dev/null)
    set prefix (string trim -r -c / $prefix)
    echo -n "$(set_color 79740e)…/$prefix$(set_color normal) "
else
    echo -n "$(set_color 79740e)"(prompt_pwd)"$(set_color normal) "
end

# sign
if not test $fish_bind_mode = insert
    echo -n "$(set_color --dim)"
end

if test $cmd_status -gt 0
    echo -n "$(set_color --underline 9d0006)"
else if jobs -q
    echo -n "$(set_color --bold b57614)"
else
    echo -n "$(set_color 79740e)"
end
echo -n "~>$(set_color normal) "
