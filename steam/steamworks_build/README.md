# SteamPipe 构建模板

此目录中的文件是 Steamworks 上传模板。上传前需要替换所有尖括号占位值。

预期本地导出路径：

```text
build/windows/RelicRunnerDemo.exe
```

典型流程：

1. 用 Godot 导出 Windows 构建。
2. 在发布机器上安装 Steamworks SDK。
3. 将 SteamPipe 内容目录指向导出的 `build/windows` 文件夹。
4. 替换 VDF 文件中的 `<DEMO_APP_ID>` 和 `<WINDOWS_DEPOT_ID>`。
5. 从 Steamworks SDK 工具目录运行 SteamPipe 上传。

不要提交 Steam 凭据或 SteamPipe 生成日志。
