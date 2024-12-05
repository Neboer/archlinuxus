#!/bin/bash -e
# because github cannot restore cache directly to high-permission directories, we need to restore them to a lower-permission directory first and then copy them to the desired directory
# restore-cache
if [ -d cache_backups ]; then
    for i in $(ls -A cache_backups); do
        rm -rf "root.x86_64/home/archlinuxus/$i"
        mv "cache_backups/$i" root.x86_64/home/archlinuxus
    done
    chown -R 1000:1000 "root.x86_64/home/archlinuxus"
fi

# use this script after github actions restore the cache. This script will move the cache to the desired directory