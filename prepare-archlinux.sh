#!/bin/bash -e

USERNAME=archlinuxus

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

function create-user-home() {
    mkdir -p "root.x86_64/home/$USERNAME"
}

function copy-project() {
    cp -r archlinuxus-scripts root.x86_64/root/
    cp -r archlinuxus-scripts "root.x86_64/home/$USERNAME/"
}

function fix-user-dir-permissions() {
    chown -R 1000:1000 "root.x86_64/home/$USERNAME"
}

curl -OL "https://mirrors.edge.kernel.org/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.zst"
tar -xf archlinux-bootstrap-x86_64.tar.zst --numeric-owner

# archlinuxus-scripts checkouted from git repo
create-user-home
copy-project
fix-user-dir-permissions

mount --bind "$PWD/root.x86_64" "$PWD/root.x86_64"
root.x86_64/bin/arch-chroot root.x86_64 /root/archlinuxus-scripts/prepare-arch-env/main.sh
