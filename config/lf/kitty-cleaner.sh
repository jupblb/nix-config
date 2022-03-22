#!/usr/bin/env bash

if [ "$TERM" = "xterm-kitty" ] && [ -x "$(command -v kitty)" ]; then
  kitty +icat --clear --silent --transfer-mode file
fi
