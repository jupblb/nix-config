#!/bin/sh

git clone --recurse-submodules https://github.com/jupblb/blog.git /tmp/blog
hugo --cleanDestinationDir -d /srv/blog -s /tmp/blog
rm -rf /tmp/blog
