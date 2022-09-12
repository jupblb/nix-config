#!/usr/bin/env fish

set -l nvim_id (jobs | grep "nvim --listen" | head -1 | awk '{print $1}')

if test -z "$nvim_id"
    rm -f $NVIM_LISTEN_ADDRESS
    nvim --listen $NVIM_LISTEN_ADDRESS $argv
    return
end

nvr --nostart --servername $NVIM_LISTEN_ADDRESS --remote $argv &
fg "%$nvim_id"
