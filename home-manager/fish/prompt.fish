#!/usr/bin/env fish

set -l cmd_status $status

# hostname
if set -q SSH_TTY
    echo -n "$(set_color 98971a)$(prompt_hostname):$(set_color normal)"
end

# pwd
echo -n "$(set_color 79740e)$(prompt_pwd)$(set_color normal) "

# icons
set -l icons

if jobs -q
    set -a icons "$(set_color d79921) "
end

if set -q IN_NIX_SHELL
    set -a icons "$(set_color 458588) "
end

if count $icons >/dev/null
    echo -n "$(string join ' ' $icons)$(set_color normal) "
end

# sign
if test $fish_bind_mode = insert
    echo -n "$(set_color --bold)"
else
    echo -n "$(set_color --dim)"
end

if test $cmd_status -gt 0
    echo -n "$(set_color --underline 9d0006)"
else
    echo -n "$(set_color 79740e)"
end

echo -n "~>$(set_color normal) "
