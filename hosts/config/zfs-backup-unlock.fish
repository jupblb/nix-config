#!/usr/bin/env fish

sudo zfs load-key -a
sudo zpool import backup
sudo mount /backup

set fish_trace 1
