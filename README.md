# 塞尔达一代重制（NES → GBA 缩小帽风格）

> 项目启动草案 V0.1（2026-09-10）— 当前阶段：项目定义 → 资源盘点 → 小型可玩样板

## 项目目标

将 NES《塞尔达传说》一代重新制作成 GBA《塞尔达传说：缩小帽》式二维像素美术与表现。

核心目标：保留一代的探索辨识度，用更丰富且一致的环境、人物、动画和界面呈现。

## 目录结构

```
zelda-remake/
├── src/        # 引擎项目源码（Godot 主候选）
├── assets/     # 美术、音效、关卡数据
├── docs/       # 项目定义、决策日志、任务模板、试玩卡点分析
├── research/   # 调研报告（scout 维护）
├── tools/      # 引擎 binary、构建辅助脚本
├── builds/     # 导出的试玩版本（不进 git）
└── README.md
```

## 当前里程碑

**样板（5-10 分钟可玩流程）**：
- 林克出现在开局场景
- 进入洞穴，与老人交互并获得剑
- 出洞，与一种代表性敌人战斗
- 切换至相邻场景，再返回
- 保存/退出/读取，正确保留取剑状态
- 验证受击、死亡与重新开始

完整游戏范围待样板完成后，按实际成本重估。

## 功能状态总览

> **状态分三级**：
> - 🟢 **已写代码** — 源码中存在实现
> - 🟡 **已运行验证** — headless / 测试 exe 在 macmini02 上自检通过
> - ✅ **用户已验收** — Surface Pro 8 / Win11 实机试玩通过

| 功能 | 已写代码 | 已运行验证 | 用户已验收 | 备注 |
|------|:---:|:---:|:---:|------|
| 玩家四向移动（WASD/方向键） | 🟢 v0.0.1 | 🟡 v0.0.1 | ✅ v0.0.1 | E01 |
| 碰墙碰撞检测 | 🟢 v0.0.1 | 🟡 v0.0.1 | ✅ v0.0.1 | E01 |
| 玩家可见（橙色方块） | 🟢 v0.0.5 | 🟡 v0.0.5 | ✅ v0.1.1 | Sprite2D+ColorRect 改为 _draw() |
| 场景切换（outdoor ↔ cave） | 🟢 v0.0.3 | 🟡 v0.0.3 | ⏳ 待验证 | v0.1.0+ |
| 取剑（has_sword = true） | 🟢 v0.0.5 | 🟡 v0.1.1 | ⏳ **本轮重点** | sword.tscn 加 8x8 shape + call_deferred queue_free |
| 攻击（空格键挥剑） | 🟢 v0.0.5 | 🟡 v0.0.5 | ⏳ 待验证 | E02 |
| 敌人（史莱姆） | 🟢 v0.0.3 | 🟡 v0.0.3 | ⏳ 待验证 | 史莱姆碰撞 + 击退 |
| 击杀敌人 | 🟢 v0.0.5 | 🟡 v0.0.5 | ⏳ **本轮重点** | E02 链：攻击→敌人受伤→死亡 |
| 存档（has_sword / room / player_xy） | 🟢 v0.0.5 | 🟡 v0.0.5 | ⏳ 待验证 | save_game() / load_game() |
| 退出重开仍持剑 | 🟢 v0.0.5 | 🟡 v0.0.5 | ⏳ **本轮重点** | user://save.dat 路径 |
| 暂停菜单（M 键） | 🟢 v0.0.5 | 🟡 v0.1.2 | ⏳ 待验证 | HBoxContainer + grab_focus |
| 菜单左右切焦点 | 🟢 v0.1.2 | 🟡 v0.1.2 | ⏳ **本轮重点** | grab_focus + FOCUS_ALL |
| 菜单退出确认 | 🟢 v0.0.5 | 🟡 v0.1.2 | ⏳ 待验证 | confirm_panel 弹窗 |
| 视口缩放（F1=1x / F2=2x / F3=3x） | 🟢 v0.0.9 | 🟡 v0.1.3 | ⏳ **本轮重点** | aspect=keep + scale_mode=fractional |

**用户拍板的视觉基线**（P01 已确认）：
- 视口：240×160（GBA 缩小帽）
- 像素比例：1:1（pixel-perfect）
- 玩家：8×8 橙色方块（持剑后变蓝）
- 墙：棕色 / 地板：深绿色

## 当前试玩版本

- **Release**：https://github.com/nocooldog/FC-Zelda-remake/releases/tag/v0.0.1
- **版本**：v0.1.3（pck sha256 `0b98bdb3...`）
- **构建**：基于 commit `1e4aeb3`（viewport缩放回归修复）
- **exe + pck**：两个文件需在同一目录，双击 exe 运行

**当前已知问题（v0.1.3）**：
- 剑拾取可能因 8×8 collision 偏小，需精确走位（v0.2 计划扩大到 12×12）
- 菜单字体仍失真（v0.2 计划换像素字体）
- Wall/Floor/Cave 装饰仍用 ColorRect（历史遗留，R02 §6.4.3 约束 #2 不合规但不阻塞）

## 协作约定

参见 `CONTRIBUTING.md`。

## 决策与任务

- 决策日志：`docs/DECISIONS.md`
- 任务模板：`docs/TASK_TEMPLATE.md`
- E01 验收报告：`docs/E01_report.md`
- v0.1.0 卡点分析：`docs/v0.1.0_BLOCKER_ANALYSIS.md`
- 调研报告：`research/`
  - `R01_engine_comparison.md` — 引擎选型
  - `R02_resource_inventory.md` — 资源盘点 + 设计参考
  - `R03_hermes_agent.md` — hermes-agent 接入面

## 试玩 / 反馈

- 实机试玩清单：`docs/PLAYTESTING.md`
- 反馈渠道：Raft #general 频道 + 截图附件
- 卡点描述模板：参考 `docs/v0.1.0_BLOCKER_ANALYSIS.md` 结构