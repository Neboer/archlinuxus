#!/bin/bash
# 用法：./restore_from_cache.sh <缓存根目录>

#######################################
# 递归恢复文件/目录到原始路径
# 参数：
#   $1 - 缓存根目录
#######################################
restore_entries() {
    local cache_root="$1"
    
    # 使用深度优先遍历处理嵌套结构
    find "$cache_root" -depth -mindepth 1 -print0 | while IFS= read -r -d '' cached_path; do
        # 计算原始系统路径
        local original_path="${cached_path#$cache_root/}"
        original_path="/$original_path"  # 恢复绝对路径
        
        # 创建目标父目录
        local target_parent=$(dirname "$original_path")
        mkdir -p "$target_parent" 2>/dev/null || {
            echo "[错误] 无法创建目录：$target_parent" >&2
            continue
        }

        # 执行移动操作（强制覆盖）
        if mv -f "$cached_path" "$original_path" 2>/dev/null; then
            echo "[恢复成功] $cached_path → $original_path"
        else
            # 处理跨设备移动的情况
            if cp -a -- "$cached_path" "$original_path" 2>/dev/null; then
                rm -rf "$cached_path"
                echo "[复制恢复] $original_path"
            else
                echo "[恢复失败] $cached_path" >&2
            fi
        fi
    done
}

# 主流程
[[ $# -ne 1 ]] && {
    echo -e "用法：$0 <缓存根目录>\n示例：$0 /mnt/cache_root" >&2
    exit 1
}

cache_root="${1%/}"  # 移除末尾的斜线
[[ ! -d "$cache_root" ]] && {
    echo "错误：无效的缓存目录：$cache_root" >&2
    exit 2
}

echo "开始从缓存恢复数据..."
restore_entries "$cache_root"

# 清理空目录
find "$cache_root" -depth -type d -empty -delete 2>/dev/null

echo -e "\n恢复操作完成！缓存目录：$cache_root"
