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
    set -g __fish_git_prompt_char_cleanstate ""
    set -g __fish_git_prompt_char_stateseparator " "
    set -g __fish_git_prompt_char_upstream_equal ""
    set -g __fish_git_prompt_showstashstate
    set -g __fish_git_prompt_showupstream informative
    set -g __fish_git_prompt_use_informative_chars 1

    if test "$TERM" = xterm-kitty # gruvbox
        set -g __fish_git_prompt_color af3a03
        set -g __fish_git_prompt_color_dirtystate b57614
        set -g __fish_git_prompt_color_merging af3a03
        set -g __fish_git_prompt_color_stagedstate 79740e
        set -g __fish_git_prompt_color_untrackedfiles 427b58
    end

    set -l git_common_dir (git rev-parse --git-common-dir 2>/dev/null)
    set -l git_toplevel (git rev-parse --show-toplevel 2>/dev/null)

    if test -n "$git_common_dir" -a -n "$git_toplevel"
        set -l repo_name "(unknown)"
        # Check if we're in a worktree
        if string match -q ".git" "$git_common_dir"
            set repo_name (basename "$git_toplevel")
        else
            set -l main_repo_dir (dirname "$git_common_dir")
            set repo_name (basename "$main_repo_dir")
        end

        echo -n " $(set_color af3a03) $repo_name$(set_color normal)$(fish_git_prompt)"
    end
end
