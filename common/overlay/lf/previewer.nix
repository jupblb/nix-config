{ atool, bat, glow, jq, poppler_utils, writeShellScript }:

writeShellScript "lf-preview" ''
  case "$1" in
    *.json)       ${jq}/bin/jq --color-output . "$1";;
    *.md)         ${glow}/bin/glow -s light - "$1";;
    *.pdf)        ${poppler_utils}/bin/pdftotext "$1" -;;
    *.tar*|*.zip) ${atool}/bin/atool --list -- "$1";;
    *)            ${bat}/bin/bat --style=numbers --color always "$1";;
  esac
''
