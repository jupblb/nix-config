#!/usr/bin/env fish

delta-view
fish_vi_key_bindings
printf '\033[5 q\r'
set -U async_prompt_functions fish_right_prompt
