#!/usr/bin/env fish

zfs load-key -a
zpool import backup
zfs mount -a
mount /backup
