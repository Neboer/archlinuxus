#!/bin/bash
# 用法：./make_snapshot.sh <目标目录> <输出文件>

#######################################
# 终止脚本并显示错误信息
# 参数：
#   $1 - 错误信息
#######################################
die() {
    echo -e "\033[31mERROR: $1\033[0m" >&2
    exit 1
}

#######################################
# 生成文件快照
# 参数：
#   $1 - 目标目录
#   $2 - 输出文件路径
#######################################
create_snapshot() {
    local target_dir="$1"
    local output_file="$2"

    echo "生成文件快照中 [$target_dir] ..."
    find "$target_dir" -type f -print | LC_ALL=C sort --parallel=$(nproc) > "$output_file" || die "快照生成失败"

    echo -e "\033[32m快照已保存至: $output_file\033[0m"
}

# 主流程
[[ $# -ne 2 ]] && die "用法：$0 <目标目录> <输出文件>"

target_dir="$1"
output_file="$2"

# 依赖检查
for cmd in find sort; do
    command -v $cmd >/dev/null || die "未找到命令：$cmd"
done

# 目录检查
[[ ! -d "$target_dir" ]] && die "目录不存在：$target_dir"

# 自动创建输出目录
mkdir -p "$(dirname "$output_file")" || die "无法创建输出目录"

create_snapshot "$target_dir" "$output_file"
