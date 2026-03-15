#!/usr/bin/env bashio

ingress_entry=$(bashio::addon.ingress_entry)

set -ex

# Check if custom files exist and copy them
if [ -d /config/ws-scrcpy ]; then
    echo "在配置文件/config/ws-scrcpy中发现源文件, 复制替换进容器/app目录"
    cp -r /config/ws-scrcpy/* /app/
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