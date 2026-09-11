# 项目封存总结（ARCHIVE）

> 封存日期：2026-09-11 09:32 · 指令：@ben-gao「这个项目做个进度总结，封存」
> 封存时 HEAD：`c453681`（STATUS.md v0.2.2 主验证线记录）

---

## 一、项目概况

- **目标**：NES《塞尔达传说》一代重制，GBA《缩小帽》风格像素表现（240×160 pixel-perfect）
- **引擎**：Godot 4.7.2 stable（MIT），GDScript
- **仓库**：https://github.com/nocooldog/FC-Zelda-remake
- **周期**：2026-09-10 单日立项 → 当晚出第一个可玩包 → 09-11 封存
- **团队**：ben-gao（拍板/验收）+ scout（调研）+ writer（文档）+ general（执行）+ Cindy（协调）

## 二、封存时进度（三态：🟡已写代码 / 🟠已运行验证 / 🟢用户已验收）

| 功能 | 状态 |
|---|---|
| 玩家四向移动 + 边界 clamp | 🟢 已验收 |
| 户外/洞穴场景切换 | 🟠 headless 验证 |
| 剑拾取（走近自动触发，玩家变蓝） | 🟢 已验收（v0.1.3，2026-09-10 22:01） |
| 剑攻击（空格白矩形 + 命中史莱姆） | 🟠 headless 验证，待用户验收 |
| 史莱姆 HP/击杀 | 🟠 同上 |
| 存档（save.dat 二进制，has_sword 持久化） | 🟠 同上 |
| M 菜单（背景框 + 焦点 + 退出确认） | 🟠 同上 |
| 缩放 F1/F2/F3（aspect=keep + fractional） | 🟠 同上 |

**最后封版**：v0.2.2（commit `939fbb1`，pck sha256 `3156eb01...`，GitHub release 上的包已核验一致）。
v0.2 / v0.2.1 已作废（菜单背景透明 + 窗口不居中，v0.2.2 已修）。

**未完成的验收**：v0.2.2 的 7 步闭环清单（进洞拾剑→出洞攻击→击杀→重开仍持剑→菜单）只跑到第 2 步（拾剑 ✅），第 3-7 步未试玩。

## 三、版本时间线

| 版本 | commit | 内容 |
|---|---|---|
| v0.0.1 | `018664f` | 首个可玩包（移动 + 边界） |
| v0.0.3-v0.0.9 | E02 链 | 洞穴、剑、史莱姆、菜单、存档 |
| v0.1.0-v0.1.3 | 多 commit | 三联 bug 修复（剑拾取/菜单/缩放），拾剑最终用户验收 |
| v0.2 / v0.2.1 | `2f064cf` / `126fe6e` | 攻击接通 + 清理（已作废：菜单透明/窗口不居中） |
| **v0.2.2** | **`939fbb1`** | **封版**：StyleBoxFlat 菜单背景 + move_to_center |

## 四、经验沉淀（恢复时必读）

1. 玩家视觉必须 `_draw()`，不挂 ColorRect/Polygon2D（Godot 4.7 tscn 序列化 bug）
2. 物理回调内删除节点必须 `call_deferred("queue_free")`
3. Area2D 必须有 CollisionShape2D（v0.1.x 剑拾取失败的真凶）
4. 导出前 `rm -rf .godot/`；exe SHA 不变，内容在 .pck
5. UI 定位只用 `get_viewport_rect().size`（viewport 模式下恒为 240×160），禁用 `OS.window_size`
6. PanelContainer 背景用 `add_theme_stylebox_override("panel", StyleBoxFlat)`；居中用 `move_to_center()`
7. 详细依据：`research/R02 §6.4.3`（v0.2.2 复核版，commit `b88caf1`）、`docs/HARD_CONSTRAINTS_REVIEW.md`

## 五、已知实现债（恢复时优先处理）

- `sword.gd` 缺 `set_deferred("monitoring", false)`（同帧重复触发风险，实际影响≈0）
- cave.tscn 装饰仍用 ColorRect（StaticBody2D 下），应改 Sprite2D/Polygon2D
- 菜单未用像素字体（默认抗锯齿字体）
- 剑 shape 仍 8×8（史莱姆已 12×12）

## 六、恢复指南

1. 环境：macmini02，Godot 4.7.2 headless，v2ray 代理 localhost:1080
2. 封版试玩：GitHub release v0.0.1 的 exe + pck（pck sha `3156eb01...`）
3. 恢复第一步：跑完 v0.2.2 剩余 7 步验收（清单在 `docs/STATUS.md`），再决定 v0.3 范围
4. 每日备份仍在进行（my-raft-team 私有仓，cron 02:00）

---

*本文档为项目封存快照，恢复前请先读 `README.md` + `docs/STATUS.md` + 本文。*
