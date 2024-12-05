#!/bin/bash -e
# create-cache

mkdir -p cache_backups

if [ -d root.x86_64/home/archlinuxus/.cache ]; then
    echo "Moving cache..."
    mv -f root.x86_64/home/archlinuxus/.cache cache_backups
fi

chown -R runner:runner cache_backups