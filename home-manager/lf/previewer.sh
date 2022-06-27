#!/usr/bin/env bash

if [ "$TERM" = "xterm-kitty" ] && [ -x "$(command -v kitty)" ]; then
  if [[ "$(file -Lb --mime-type "$1")" =~ ^image ]]; then
    kitty +icat --silent --transfer-mode file --place "$2x$3@$4x$5" "$1"
    exit 1
  fi
fi
