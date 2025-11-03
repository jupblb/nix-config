#!/usr/bin/env fish

sudo zpool import backup
sudo zfs load-key -a
sudo mount /backup
