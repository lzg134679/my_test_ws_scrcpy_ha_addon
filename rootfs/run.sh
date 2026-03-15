#!/usr/bin/env bashio

ingress_entry=$(bashio::addon.ingress_entry)

set -ex

# Check if custom files exist and copy them
echo "检查/config/ws-scrcpy目录..."
ls -la /config/ || echo "无法列出/config目录"
if [ -d /config/ws-scrcpy ]; then
    echo "在配置文件/config/ws-scrcpy中发现源文件, 复制替换进容器/app目录"
    ls -la /config/ws-scrcpy/ || echo "无法列出/config/ws-scrcpy目录"
    cp -r /config/ws-scrcpy/* /app/
    echo "复制完成，检查/app目录..."
    ls -la /app/src/style/ || echo "无法列出/app/src/style目录"
else
    echo "未在配置文件/config/ws-scrcpy中发现源文件, 使用默认文件"
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