#!/usr/bin/env sh

find /data/dropbox/scans -mmin -60 -exec cp {} /data/paperless-inbox/
