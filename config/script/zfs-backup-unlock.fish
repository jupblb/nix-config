#!/usr/bin/env fish

sudo zfs load-key -a
sudo mount /backup
sudo systemctl start calibre-web.service
sudo systemctl start paperless-ng-server.service
sudo systemctl start syncthing.service
