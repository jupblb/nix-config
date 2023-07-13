#!/usr/bin/env fish
# https://github.com/evanpurkhiser/dots-personal/blob/main/base/bash/functions.d/vim-singleton

set -l nvim_id (jobs | grep "nvim --listen" | head -1 | awk '{print $1}')

if test -z "$nvim_id"
    rm -f $NVIM_LISTEN_ADDRESS
    nvim --listen $NVIM_LISTEN_ADDRESS $argv
    return
end

# https://github.com/neovim/neovim/issues/18519
for i in (seq 1 (count $argv))
    if test -e $argv[$i]
        set argv[$i] (realpath $argv[$i])
    end
end

nvim --server $NVIM_LISTEN_ADDRESS --remote $argv
fg "%$nvim_id"
