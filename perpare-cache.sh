#!/bin/bash -e
# create-cache
CACHE_DIRS=(
    root.x86_64/var/cache
    root.x86_64/home/archlinuxus/.cache
)

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