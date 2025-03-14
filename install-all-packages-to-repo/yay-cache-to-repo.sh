#!/bin/bash -e

function prepare-repo() {
    mkdir -p "/home/$USERNAME/repo/x86_64"
}

function move-all-packages-to-repo() {
    # find "/home/$USERNAME/.cache/yay" -name "*.pkg.tar.*" -exec cp -t "/home/$USERNAME/repo/x86_64/" {} +
    # echo "Moved all packages to repo."
    # ls -l "/home/$USERNAME/repo/x86_64"

    base_dir="/home/$USERNAME/.cache/yay"
    target_dir="/home/$USERNAME/repo/x86_64"

    # 确保目标目录存在
    mkdir -p "$target_dir"

    # 遍历一级子目录
    for pkg_dir in "$base_dir"/*/; do
        # 跳过非目录文件
        [ -d "$pkg_dir" ] || continue

        # 查找当前目录中最新 .pkg.tar.* 文件（按修改时间排序）
        latest_file=$(find "$pkg_dir" -maxdepth 1 -type f -name '*.pkg.tar.*' -printf "%T@ %p\n" 2>/dev/null |
            sort -nr | head -n1 | cut -d' ' -f2-)

        # 如果找到文件则处理
        if [[ -n "$latest_file" ]]; then
            # 复制文件到目标目录
            cp -f "$latest_file" "$target_dir/"

            # 计算并打印相对路径（相对于 base_dir）
            rel_path="${latest_file#$base_dir/}"
            echo "$rel_path"
        fi
    done

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
