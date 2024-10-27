##!/usr/bin/env bash

RESOLUTION=$1

if [ -z "$RESOLUTION" ]; then
  echo "Usage: $0 <resolution>"
  exit 1
fi

MODE=$(gnome-randr query HDMI-1 | grep "$RESOLUTION" | awk '{ print $1 }' | head -1)

gnome-randr modify --mode="$MODE" --scale=2 HDMI-1
