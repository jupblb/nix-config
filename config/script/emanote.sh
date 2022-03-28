#!/usr/bin/env sh

TMP_DIR="/tmp/emanote"

dump_notes() {
	SRC_DIR=$1
	SRV_DIR=$2

	mkdir -p "$SRV_DIR-tmp"
	emanote -L "$SRC_DIR" gen "$SRV_DIR-tmp"
	rm -rf "$SRV_DIR"
	mv "$SRV_DIR-tmp" "$SRV_DIR"
}

translate_to_pl() {
	DIR=$1
	find "$DIR" -type f -name '*.html' -exec sed -i "s/Home/Strona główna/g" {} \;
	find "$DIR" -type f -name '*.html' \
		-exec sed -i "s/Generated by/Wygenerowano z pomocą/g" {} \;
	find "$DIR" -type f -name '*.html' \
		-exec sed -i "s/Links to this page/Linki do tej strony/g" {} \;
}

cp -r /backup/jupblb/Documents/notes $TMP_DIR

# Delete anything above 100MB in size
find $TMP_DIR -type f -size +100M -delete
# Fix links by translating them to the obsidian format
find $TMP_DIR -type f -iname '*.md' \
	-exec sed -i -E "s/\[([^(]+)\]\(([^)]+\/)*([^)]+)\.md\)/\[\[\3\|\1\]\]/g" {} \;
# Fix images by translating them to the obsidian format
find $TMP_DIR -type f -iname '*.md' \
	-exec sed -i -E "s/!\[[^]]*\]\((.+\/)*([^]]+)\)/!\[\[\2\]\]/g" {} \;

dump_notes "$TMP_DIR" "/srv/emanote"
dump_notes "$TMP_DIR/psychology" "/srv/emanote-swps"

translate_to_pl "/srv/emanote-swps"

rm -rf $TMP_DIR
