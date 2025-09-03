#!/usr/bin/env fish

delta-view
fish_vi_key_bindings

bind -M insert \cr history-pager

set -gx __fish_git_prompt_char_cleanstate ""
set -gx __fish_git_prompt_char_stateseparator " "
set -gx __fish_git_prompt_char_upstream_equal ""
set -gx __fish_git_prompt_showstashstate
set -gx __fish_git_prompt_showupstream informative
set -gx __fish_git_prompt_use_informative_chars 1

set -U fish_cursor_default block
set -U fish_cursor_insert line
set -U fish_cursor_replace_one underscore
set -U fish_cursor_visual block

set -U async_prompt_functions fish_right_prompt
