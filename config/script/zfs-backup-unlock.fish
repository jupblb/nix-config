#!/usr/bin/env fish

sudo zfs load-key -a
sudo mount /backup
sudo systemctl start calibre-web.service
sudo systemctl start komga.service
sudo systemctl start paperless-consumer.service
sudo systemctl start paperless-scheduler.service
sudo systemctl start paperless-web.service
sudo systemctl start syncthing.service
sudo systemctl start podman-simply-shorten.service
