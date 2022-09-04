#!/usr/bin/env fish

set -l cmd_status $status

if set -q SSH_TTY
    echo -n "$(set_color 98971a)$(prompt_hostname):$(set_color normal)"
end

echo -n "$(set_color 79740e)$(prompt_pwd)$(set_color normal) "

set -l icons

if jobs -q
    set -a icons "$(set_color d79921) "
end

if set -q IN_NIX_SHELL
    set -a icons "$(set_color 458588) "
end

# if kubectl config view --minify &>/dev/null
#     set -a icons "$(set_color 458588) "
# end

if set -q icons[1]
    echo -n "$(string join ' ' $icons)$(set_color normal) "
end

if test $cmd_status -gt 0
    echo -n "$(set_color --bold --underline 9d0006)~>$(set_color normal) "
else
    echo -n "$(set_color --bold 79740e)~>$(set_color normal) "
end
