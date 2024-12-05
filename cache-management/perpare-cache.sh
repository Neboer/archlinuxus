#!/bin/bash -e
# create-cache
# need rsync to run the script.

source cache-management/cache-target.sh

mkdir -p cache_backups
for i in ${CACHE_DIRS[@]}; do
    if [ -d $i ]; then
        mv $i cache_backups
    fi
done


if [ -d root.x86_64/home/archlinuxus/.cache ]; then
    mv root.x86_64/home/archlinuxus/.cache cache_backups
fi
chown -R runner:runner cache_backups