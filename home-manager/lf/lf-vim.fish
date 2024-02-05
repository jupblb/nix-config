#!/usr/bin/env fish
# https://github.com/gokcehan/lf/blob/master/etc/lfcd.fish

set bin (which lf)
set tmp (mktemp)

if test -e $FILE && not count $argv >/dev/null
    # https://github.com/gokcehan/lf/issues/939
    $bin -selection-path=$tmp $FILE
else
    $bin -selection-path=$tmp $argv
end

if test -f $tmp
    set files (cat $tmp)
    rm -f $tmp
    if test -n "$files"
        vim $files
    end
end
