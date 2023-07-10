#!/usr/bin/env bash

if [ "$TERM" = "xterm-kitty" ] && [ -x "$(command -v kitty)" ]; then
  kitty +icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
fi
