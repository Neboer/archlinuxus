#!/bin/bash
# 用法：./restore_from_cache.sh <缓存根目录>

#######################################
# 递归恢复文件到原始路径
# 参数：
#   $1 - 缓存根目录
#######################################
restore_files() {
    local cache_root="$1"
    
    find "$cache_root" -type f -print0 | while IFS= read -r -d '' file; do
        # 计算原始路径
        local original_path="${file#$cache_root}"
        
        # 创建目标目录
        local target_dir=$(dirname "$original_path")
        mkdir -p "$target_dir" || {
            echo "[错误] 目录创建失败：$target_dir"
            continue
        }
        
        # 执行移动操作
        if mv -f "$file" "$original_path"; then
            echo "[恢复] $file → $original_path"
            # 清理空目录（可选）
            find "$(dirname "$file")" -type d -empty -delete 2>/dev/null
        else
            echo "[失败] 无法移动：$file"
        fi
    done
# 主流程
[[ $# -ne 1 ]] && echo -e "用法：$0 <缓存根目录>\n示例：$0 /mnt/cache_root" >&2 && exit 1

cache_root="$1"
[[ ! -d "$cache_root" ]] && echo "缓存目录不存在：$cache_root" >&2 && exit 2

echo "开始从缓存恢复文件..."
restore_files "$cache_root"

echo -e "\n恢复操作完成！原始路径：$cache_root"
