#!/usr/bin/env fish

sudo zfs load-key -a
sudo mount /backup

sudo systemctl restart calibre-web.service
sudo systemctl restart komga.service
sudo systemctl restart photoprism.service
sudo systemctl restart podman-filebrowser.service
sudo systemctl restart podman-simply-shorten.service
sudo systemctl restart postgresqlBackup.service
sudo systemctl restart restic-backups-gcs.service
sudo systemctl restart restic-backups-local.service
sudo systemctl restart stignore.service
sudo systemctl restart syncthing-init.service
sudo systemctl restart syncthing.service
