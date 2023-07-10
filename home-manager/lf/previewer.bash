#!/usr/bin/env bash

if [ "$TERM" = "xterm-kitty" ] && [ -x "$(command -v kitty)" ]; then
  if [[ "$(file -Lb --mime-type "$1")" =~ ^image ]]; then
    kitty +kitten icat --silent --stdin no --transfer-mode file --place "$2x$3@$4x$5" "$1" < /dev/null > /dev/tty
    exit 1
  fi
fi
