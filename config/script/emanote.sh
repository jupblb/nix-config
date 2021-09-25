#!/bin/sh

TMP_DIR="/tmp/emanote"

dump_notes() {
  SRC_DIR=$1
  SRV_DIR=$2

  mkdir -p "$SRV_DIR-tmp"
  cd "$SRC_DIR" && emanote gen "$SRV_DIR-tmp"
  rm -rf "$SRV_DIR"
  mv "$SRV_DIR-tmp" "$SRV_DIR"
}

cp -r /backup/jupblb/Documents/notes $TMP_DIR

# Delete anything above 10MB in size
find $TMP_DIR -type f -size +10M -delete
# Fix links by translating them to the wiki format
find $TMP_DIR -type f \
  -exec sed -i -E "s/\[([^\(]+)\]\([^\)]*([a-z0-9]{8})\.md\)/\[\[\2\|\1\]\]/g" {} \;

dump_notes "$TMP_DIR" "/srv/emanote"
dump_notes "$TMP_DIR/psychology" "/srv/emanote-swps"

rm -rf $TMP_DIR
