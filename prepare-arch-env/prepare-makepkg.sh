#!/bin/bash

# 关闭历史扩展，避免 ! 被解析为历史事件
set +H

file="/etc/makepkg.conf"

# 提取 OPTIONS 行并加载为变量
eval "$(grep '^OPTIONS=' "$file")"

# 处理 debug 选项
has_debug=0
has_negated_debug=0

# 遍历数组元素
for i in "${!OPTIONS[@]}"; do
    case "${OPTIONS[i]}" in
        "debug")
            OPTIONS[i]="!debug"
            has_debug=1
            ;;
        "!debug")
            has_negated_debug=1
            ;;
    esac
done

# 如果既没有 debug 也没有 !debug，则添加 !debug
if [[ $has_debug -eq 0 && $has_negated_debug -eq 0 ]]; then
    OPTIONS+=("!debug")
fi

# 构建新的 OPTIONS 行并替换原文件
new_line="OPTIONS=(${OPTIONS[@]})"
sed -i.bak "/^OPTIONS=/c$new_line" "$file"
