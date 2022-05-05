#!/usr/bin/env fish

# https://github.com/dandavison/delta/issues/359#issuecomment-799628302
if test "$COLUMNS" -ge 160; and ! contains side-by-side "$DELTA_FEATURES"
    set --global --export --append DELTA_FEATURES side-by-side
else if test "$COLUMNS" -lt 160; and contains side-by-side "$DELTA_FEATURES"
    set --erase DELTA_FEATURES[(contains --index side-by-side "$DELTA_FEATURES")]
end
