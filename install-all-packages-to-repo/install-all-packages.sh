#!/bin/bash -e

function yay-install-package() {
    LANG=C yay --answerdiff None --answerclean None --mflags "--noconfirm" --noconfirm -S "$1"
}

function install-all-packages() {
    while IFS= read -r package; do
        yay-install-package "$package"
    done < targets.txt
}

install-all-packages
