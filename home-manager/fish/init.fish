#!/usr/bin/env fish

delta-view
fish_vi_key_bindings

set -U fish_cursor_default block
set -U fish_cursor_insert line
set -U fish_cursor_replace_one underscore
set -U fish_cursor_visual block

set -U async_prompt_functions fish_right_prompt
