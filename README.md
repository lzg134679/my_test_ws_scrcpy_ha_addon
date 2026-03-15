# Scrcpy Web

1. 进入【配置】页面添加adb设备
    ```yaml
    hosts:
      - 192.168.1.100:5555
      - 192.168.1.200:5555
    ```
2. 重启加载项
3. 在安卓设备上同意调试

# 替换文件说明
1. 允许在ha配置文件中更换自定义文件
2. 配置文件路径：/config/ws-scrcpy（如不存在需自行新建）
3. 自定义文件会替换容器内的对应路径文件
4. 例如需要替换/src/style/app.css，则将修改后的app.css放入/config/ws-scrcpy/src/style/app.css
5. 重启加载项后对应文件将替换进docker容器内的/app/src/style/app.css
