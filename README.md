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

详细状态表（每个功能含三态标签 + 关联 commit hash + 关联 pck sha256）见 **`docs/STATUS.md`**。

> **状态三态**：
> - 🟡 **已写代码** — 源码中存在实现，commit 在仓，未运行过
> - 🟠 **已运行验证** — 本地 headless / 测试 exe 在 macmini02 跑通过
> - 🟢 **用户已验收** — Surface Pro 8 / Win11 实机试玩通过

**当前 v0.2 闭环目标**：
新游戏 → 进洞拾剑 → 出洞攻击史莱姆 → 击杀 → 退出重开仍持剑

| 摘要（11 个核心功能） | 已写代码 | 已运行验证 | 用户已验收 |
|---|:---:|:---:|:---:|
| 玩家移动（WASD / 方向键四向） | 🟡 | 🟠 | 🟢 |
| 玩家边界 clamp | 🟡 | 🟠 | 🟢 |
| 户外 overworld 场景 | 🟡 | 🟠 | ⏳ |
| 洞穴场景（进/出） | 🟡 | 🟠 | ⏳ |
| 剑拾取（has_sword 同步） | 🟡 | 🟠 | ⏳ |
| 剑攻击（空格挥剑） | 🟡 | 🟠 | ⏳ |
| 敌人史莱姆（HP + 击杀） | 🟡 | 🟠 | ⏳ |
| 存档系统（退出重开保留 has_sword） | 🟡 | 🟠 | ⏳ |
| 菜单系统（M 弹出 + 装备 + 退出） | 🟡 | 🟠 | ⏳ |
| 缩放 F1/F2/F3 | 🟡 | 🟠 | ⏳ |
| PowerShell 无 queue_free 物理回调违规 | 🟡 | ⏳ | ⏳ |

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