#!/bin/bash -e

function prepare-repo() {
    mkdir -p "/home/$USERNAME/repo/x86_64"
}

function move-all-packages-to-repo() {
    find "/home/$USERNAME/.cache/yay" -name "*.pkg.tar.*" -exec cp -t "/home/$USERNAME/repo/x86_64/" {} +
    echo "Moved all packages to repo."
    ls -l "/home/$USERNAME/repo/x86_64"
}

# function import-gnupg-key() {
#     gpg --import /home/$USERNAME/.gnupg/pubring.kbx
# }

function generate-db-file() {
    # use -s -k key to add signature, we simply skip the signing stage.
    cd "/home/$USERNAME/repo/x86_64"
    repo-add "archlinuxus.db.tar.gz" *
}

prepare-repo
move-all-packages-to-repo
generate-db-file
cd "$PROJ_DIR"
