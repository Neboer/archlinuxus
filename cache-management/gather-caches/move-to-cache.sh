#!/bin/bash
# 用法：./move_to_cache.sh <文件列表> <目标根目录>

#######################################
# 安全移动文件/目录并创建路径
# 参数：
#   $1 - 原始路径
#   $2 - 目标根目录
#######################################
safe_move() {
    local src="$1"
    local dest_root="$2"

    # 检查路径是否存在
    [[ ! -e "$src" ]] && { echo "路径不存在：$src" >&2; return 1; }

    # 构造目标路径
    local dest_path="${dest_root}${src}"
    local dest_dir=$(dirname "$dest_path")

    # 创建目标父目录
    mkdir -p "$dest_dir" || { echo "目录创建失败：$dest_dir" >&2; return 2; }

    # 执行移动操作
    if mv -- "$src" "$dest_path"; then
        return 0
    else
        echo "移动操作失败：$src → $dest_path" >&2
        return 3
    fi
}

# 主流程
[[ $# -ne 2 ]] && { 
    echo -e "用法：$0 <文件列表> <目标根目录>\n示例：$0 newfiles.txt /mnt/cache_root" >&2
    exit 1
}

list_file="$1"
dest_root="$2"

[[ ! -f "$list_file" ]] && { echo "文件列表不存在：$list_file" >&2; exit 2; }

echo "开始迁移文件到缓存目录..."
while IFS= read -r line; do
    [[ -z "$line" ]] && continue  # 跳过空行

    safe_move "$line" "$dest_root"
    case $? in
        0) echo "[OK] $line" ;;
        1) echo "[跳过] 路径不存在：$line" ;;
        2) echo "[错误] 目录创建失败：$(dirname "$dest_root$line")" ;;
        3) echo "[失败] 移动操作失败：$line → ${dest_root}${line}" ;;
    esac
done < "$list_file"

echo -e "\n操作完成！数据已迁移到：$dest_root"
