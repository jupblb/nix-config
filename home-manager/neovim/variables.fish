#!/usr/bin/env fish

set -q jq;  or set -l jq  "jq"
set -q sed; or set -l sed "sed"
set -q tr;  or set -l tr  "tr"

if test -e $NVIM_ENV_JSON
    for value in \
        ($jq -r 'keys[] as $k | "\($k) \(.[$k])"' $NVIM_ENV_JSON)
        set -l value (echo "$value" | $sed 's/\",\"/\"\ \"/g')
        set -l value (echo "$value" | $tr -d '[]')
        eval "set -gx $value"
    end
end
