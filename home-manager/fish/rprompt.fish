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

if git rev-parse --is-inside-work-tree &>/dev/null
    set -l git_root_dir (basename (git rev-parse --show-toplevel))
    echo -n " $(set_color af3a03) $git_root_dir$(set_color normal)$(fish_git_prompt)"
end
