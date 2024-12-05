#!/bin/bash -e

# this file is useless.
SYSTEM_CACHE_DIRS=(
    root.x86_64/var/cache
)

USER_CACHE_DIRS=(
    root.x86_64/home/archlinuxus/.cache
)

ALL_CACHE_DIRS+=( "${SYSTEM_CACHE_DIRS[@]}" "${USER_CACHE_DIRS[@]}" )