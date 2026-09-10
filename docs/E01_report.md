# E01 报告：环境检查与 Godot 验证

**日期**：2026-09-10
**负责人**：@general
**状态**：✅ 完成

## 关键命令

### 启动 Godot（headless）
```bash
/home/ben/zelda-remake/.local/godot/Godot_v4.7.2-stable_linux.x86_64 \
  --headless --path /home/ben/zelda-remake/src --editor --quit
```

### 导出 Windows exe
```bash
/home/ben/zelda-remake/.local/godot/Godot_v4.7.2-stable_linux.x86_64 \
  --headless --path /home/ben/zelda-remake/src \
  --export-release "Windows" \
  /home/ben/zelda-remake/builds/zelda-prototype.exe
```

## 关键路径

| 项 | 路径 |
|---|---|
| Godot 引擎 | `/home/ben/zelda-remake/.local/Godot_v4.7.2-stable_linux.x86_64` |
| 导出模板 | `~/.local/share/godot/export_templates/4.7.2.stable/` |
| 项目入口 | `/home/ben/zelda-remake/src/project.godot` |
| 玩家脚本 | `/home/ben/zelda-remake/src/scripts/player.gd` |
| 主场景 | `/home/ben/zelda-remake/src/scenes/main.tscn` |
| 导出配置 | `/home/ben/zelda-remake/src/export_presets.cfg` |
| 构建产物 | `/home/ben/zelda-remake/builds/zelda-prototype.exe` |

## 版本信息

- Godot：4.7.2.stable.official.ed1daf0bf
- Git commit：`f320973`

## 当前实现功能

- 四向移动（WASD / 方向键）
- 碰撞检测（CharacterBody2D + StaticBody2D）
- 边界限制（256×224 像素视口）

## 已知限制

- 图形为占位色块，E02 进行风格化替换
- 未实现：取剑、战斗、场景切换、存档

## 网络约束（O-005）

macmini02 无直连互联网，通过 v2ray 代理（`localhost:1080`）访问 GitHub/GitLab。
