#!/usr/bin/env fish

set -l cmd_duration $CMD_DURATION

# https://github.com/IlanCosman/tide/blob/main/functions/_tide_item_cmd_duration.fish
if test $cmd_duration -gt 3000
    echo -n " $(set_color 928374)󰄉 "

    set -l minutes (math --scale=0 "$CMD_DURATION/60000")
    if test $minutes -gt 0
        echo -n "$minutes""m"
    end

    set -l seconds (math --scale=$tide_cmd_duration_decimals "$CMD_DURATION/1000"%60)
    if test $seconds -gt 0
        echo -n "$seconds""s"
    end

    echo -n "$(set_color normal)"
end

set -l git_common_dir (git rev-parse --git-common-dir 2>/dev/null)
set -l git_toplevel (git rev-parse --show-toplevel 2>/dev/null)
if test -n "$git_common_dir" -a -n "$git_toplevel"
    # Find the real repository root even inside a linked work-tree
    if not string match -q "/*" -- $git_common_dir
        set git_common_dir (realpath $git_common_dir)
    end

    while test (basename $git_common_dir) != ".git"
        set git_common_dir (dirname $git_common_dir)
    end
    set -l repo_name (basename (dirname $git_common_dir))

    echo -n " $(set_color af3a03) $repo_name$(set_color normal)$(fish_git_prompt)"
end
