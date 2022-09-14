#!/usr/bin/env fish
# https://github.com/gokcehan/lf/blob/master/etc/lfcd.fish

set tmp (mktemp)
lf -selection-path=$tmp $argv

if test -f $tmp
    set files (cat $tmp)
    rm -f $tmp
    if test -n "$files"
        vim $files
    end
end
