#!/usr/bin/env sh

cd /backup/jupblb/Workspace

python3 generate-stignore.py > /tmp/stignore

# https://unix.stackexchange.com/a/397657
if cmp -s /backup/jupblb/Workspace/stignore /tmp/stignore; then
	>&2 echo "Skipping stignore update"
	rm /tmp/stignore
else
	>&2 echo "Updating stignore"
	mv /tmp/stignore /backup/jupblb/Workspace/stignore
fi
