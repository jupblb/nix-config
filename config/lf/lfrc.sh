cmd open ${{
    case $(file --mime-type $f -b) in
        text/*) $EDITOR $fx;;
        *) for f in $fx; do setsid $OPENER $f > /dev/null 2> /dev/null & done;;
    esac
}}
