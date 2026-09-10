# P00 环境与平台假设报告

**完成日期**：2026-09-10
**负责人**：@Cindy
**状态**：✅ 已拍板（@ben-gao 在 #general:c503da3d thread 确认）

## 机器

| 项 | 值 |
|---|---|
| 主机 | macmini02 |
| OS | Ubuntu 22.04（kernel 6.8.0-138-generic） |
| 用户 | `ben`（uid 1000） |
| 用户组 | sudo / docker |
| 内存 | 15G（已用 2G，可用 13G） |
| 交换 | 2G |
| 根分区 | 117G，已用 26G，可用 86G |

## 工具链

| 工具 | 状态 | 版本 |
|---|---|---|
| git | ✅ | 2.34.1 |
| python3 | ✅ | - |
| docker daemon | ✅ | 已有 cadvisor 容器运行 |
| Godot | ❌→✅ 计划装 | godotengine.org 可达，可下 binary |
| Solarus | ❌→计划查 | gitlab.com 可达，可 clone |
| ZQuest Classic | ❌ GitHub 不可达 | 仅做文档级核查 |

## 网络（O-005 决策项）

| 目标 | 状态 |
|---|---|
| github.com | ❌ 超时 |
| godotengine.org | ✅ 200 |
| gitlab.com | ✅ 301 |
| Docker Hub | ✅ 可达 |
| Google | ❌ 超时 |

**影响**：R01/R02 中 GitHub 来源的参考项目只能"文档级核查"；Godot 主方案 + Solarus 备选完全可行。

## 平台假设（已采纳的默认）

- **仓库根路径**：`/home/ben/zelda-remake/`（用户已确认）
- **试玩方案**：用户本地（带桌面的机器）拉代码试玩，录屏/截图反馈给团队（用户已确认接受 headless 服务器限制）
- **引擎候选**：Godot 主 + Solarus 备选（基于可达性 + 文档 §6 倾向）
- **协作单位**：Raft 频道用于状态/讨论 + git 仓用于代码/文档/调研

## 待用户后续拍板项（不阻塞样板阶段）

- 视觉风格细节（色板方向、人物尺寸 vs 原版比例）
- 移动方向、攻击距离、无敌时间参数（§3.3 强调不要直接搬缩小帽）
- 完整第一轮冒险的范围（第一座迷宫何时启动）

## 仓库结构

```
zelda-remake/
├── src/        # Godot 项目源码
├── assets/     # 美术、音效、关卡数据
├── docs/       # 项目定义、决策日志、模板
├── research/   # 调研报告（scout 维护）
├── tools/      # 引擎 binary、构建脚本
├── README.md
├── CONTRIBUTING.md
└── .gitignore
```