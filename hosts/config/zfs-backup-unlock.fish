#!/usr/bin/env fish

zpool import backup
zfs load-key -a
mount /backup
