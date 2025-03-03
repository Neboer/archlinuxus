#!/bin/bash
# 用法：./diff_snapshot.sh <旧快照文件> <新快照文件> <输出文件>

#######################################
# 终止脚本并显示错误信息
# 参数：
#   $1 - 错误信息
#######################################
die() {
    echo -e "\033[31mERROR: $1\033[0m" >&2
    exit 1
}

# 参数校验
[[ $# -ne 3 ]] && die "用法：$0 <旧快照文件> <新快照文件> <输出文件>"

old_snap="$1"
new_snap="$2"
output_file="$3"

# 文件存在性检查
for file in "$old_snap" "$new_snap"; do
    [[ ! -f "$file" ]] && die "文件不存在：$file"
done

# 依赖检查
command -v comm >/dev/null || die "未找到命令：comm"

# 执行差异对比
echo "正在计算增量文件..."
LC_ALL=C comm -13 "$old_snap" "$new_snap" > "$output_file" || die "差异对比失败"

echo -e "\033[32m新增文件已保存至：$output_file\033[0m"
