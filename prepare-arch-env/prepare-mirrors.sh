#!/bin/bash -e

function prepare-basic-mirror() {
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    echo 'Server = https://arch.mirror.constant.com/$repo/os/$arch' > /etc/pacman.d/mirrorlist
}

function prepare-keys() {
    pacman-key --init
    pacman-key --populate
}

function upgrade-and-rank-mirrors() {
    pacman -S pacman-contrib --noconfirm
    awk '/^## United States$/{f=1; next}f==0{next}/^$/{exit}{print substr($0, 1);}' /etc/pacman.d/mirrorlist.backup
    sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
    rankmirrors -n 2 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
}

function add-multilib() {
    echo '[multilib]' >> /etc/pacman.conf
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
}

prepare-basic-mirror
prepare-keys
add-multilib
pacman -Syu --noconfirm
# upgrade-and-rank-mirrors
# echo "ranked mirrors:"
# cat /etc/pacman.d/mirrorlist