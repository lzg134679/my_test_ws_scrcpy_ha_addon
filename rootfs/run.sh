#!/usr/bin/env bashio

ingress_entry=$(bashio::addon.ingress_entry)

set -ex

# Check if BuildCompeted file exists
BUILD_COMPLETED_FILE="/config/ws-scrcpy/BuildCompeted"

if [ -f "$BUILD_COMPLETED_FILE" ]; then
    echo "发现BuildCompeted文件，跳过文件替换和重建步骤"
else
    # Check if custom files exist and copy them
    echo "检查加载项addon_configs目录..."
    ls -la /config/ws-scrcpy/ || echo "无法列出/config/ws-scrcpy/目录"
    if [ -d /config/ws-scrcpy ]; then
        # Check if directory is not empty
        if [ "$(ls -A /config/ws-scrcpy/)" ]; then
            echo "在加载项配置目录/config/ws-scrcpy/中发现源文件, 复制替换进容器/app目录"
            cp -r /config/ws-scrcpy/* /app/
            echo "复制完成"
            
            # Rebuild the project to apply the changes
            echo "重新构建项目以应用修改..."
            cd /app && npm run dist
        else
            echo "加载项配置目录/config/ws-scrcpy/为空，跳过文件复制和重建"
        fi
        
        # Create BuildCompeted file to indicate successful build
        echo "创建BuildCompeted文件以标记构建完成"
        touch "$BUILD_COMPLETED_FILE"
    else
        echo "未在加载项配置目录/config/ws-scrcpy/中发现源文件, 使用默认文件运行"
        # Skip rebuild when no custom files
        echo "没有自定义文件，跳过重建步骤"
    fi
fi

sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/http.d/*.conf
nginx -g "error_log /dev/stdout info;"

if [ ! -d "$ANDROID_HOME" ]; then
    mkdir -p "$ANDROID_HOME"
fi

CONFIG_PATH=/data/options.json
jq -r '.hosts[]' $CONFIG_PATH | while IFS=':' read -r addr port; do
    adb connect $addr:$port
done

exec "$@"