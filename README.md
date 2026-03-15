# Scrcpy Web

1. 进入【配置】页面添加adb设备
   ```yaml
   hosts:
     - 192.168.66.28:5555
     - 192.168.66.80:5555
   ```
2. 重启加载项
3. 在安卓设备上同意调试

# 替换文件说明

1. 允许在ha的加载项配置文件中更换自定义文件
2. 配置文件路径：/addon\_configs/xxxxxxxx\_scrcpy/ws-scrcpy/（如不存在需连接手机成功后再重启一次加载项，等几分钟会自动生成）
3. 例如需要替换/src/style/app.css，则将修改后的app.css放入/addon\_configs/xxxxxxxx\_scrcpy/ws-scrcpy/src/style/app.css
4. 重启加载项后对应文件将替换进docker容器内的/app/src/style/app.css，并且会自行重建ws-scrcpy，请耐心等待（真要很久）
5. 后续每次重启都需要等待重建完成，否则会变回默认状态