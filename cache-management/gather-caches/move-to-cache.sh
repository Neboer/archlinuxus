#!/bin/bash
# 用法：./move_to_cache.sh <文件列表> <目标根目录>

#######################################
# 安全移动文件并创建路径
# 参数：
#   $1 - 原始文件路径
#   $2 - 目标根目录
#######################################
safe_move() {
    local src="$1"
    local dest_root="$2"
    
    [[ ! -f "$src" ]] && echo "源文件不存在：$src" >&2 && return 1
    
    # 构造目标路径
    local dest_path="${dest_root}${src}"
    local dest_dir=$(dirname "$dest_path")
    
    # 创建目标目录
    mkdir -p "$dest_dir" || return 2
    
    # 执行移动操作
    mv -- "$src" "$dest_path" || return 3
}

# 主流程
[[ $# -ne 2 ]] && echo -e "用法：$0 <文件列表> <目标根目录>\n示例：$0 newfiles.txt /mnt/cache_root" >&2 && exit 1

list_file="$1"
dest_root="$2"

[[ ! -f "$list_file" ]] && echo "文件列表不存在：$list_file" >&2 && exit 2

echo "开始迁移文件到缓存目录..."
while IFS= read -r line; do
    safe_move "$line" "$dest_root"
    case $? in
        0) echo "[OK] $line" ;;
        1) echo "[跳过] 源文件不存在：$line" ;;
        2) echo "[错误] 目录创建失败：$dest_dir" ;;
        3*) echo "[失败] 移动操作失败：$line → ${dest_path}" ;;
    esac
done < "$list_file"

echo -e "\n操作完成！文件已迁移到：$dest_root"
