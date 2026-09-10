# 决策日志

> 来源：塞尔达一代重制项目
> 维护人：@writer
> 说明：本文件记录所有已确认的决策，包括决策内容、依据、状态和来源。任何后续文档不得将待确认事项改写为已确认。

---

## 决策状态说明

- ✅ **已确认** — 团队或用户明确决定，不可逆或需要用户授权才能变更
- 🔄 **推荐默认** — 尚未正式确认，以该方案推进；如有异议在收口前提出
- ⏳ **待确认** — 尚未决定，推进前需 @Cindy 收口或用户决策
- ❌ **已否决** — 明确不在当前范围内

---

## 项目级决策

| 编号 | 决策内容 | 状态 | 依据/备注 | 来源 |
|------|----------|------|-----------|------|
| D-001 | 重制对象为 NES《塞尔达传说》一代 | ✅ 已确认 | 用户明确目标 | PROJECT_DEF_V0.1 §1 |
| D-002 | 美术风格参考 GBA《缩小帽》 | ✅ 已确认 | 用户明确目标 | PROJECT_DEF_V0.1 §1 |
| D-003 | 平台：先开发电脑版（键盘+手柄） | 🔄 推荐默认 | 不等于 GBA 原生；待用户确认 | PROJECT_DEF_V0.1 §2 |
| D-004 | 引擎候选：Godot 为主，ZQuest Classic 为辅，Solarus 为备选 | 🔄 推荐默认 | 尚未最终选定；依赖 R01/E01 核查 | PROJECT_DEF_V0.1 §2 |
| D-005 | 若选 Godot，使用 GDScript 并锁定引擎版本 | 🔄 推荐默认 | 条件性推荐，待引擎确定 | PROJECT_DEF_V0.1 §2 |
| D-006 | 开发范围：先完成第一轮冒险（样板通过后） | 🔄 推荐默认 | 不承诺完整游戏工期 | PROJECT_DEF_V0.1 §2 |
| D-007 | 当前阶段顺序：项目定义 → 资源盘点 → 可玩样板 | ✅ 已确认 | 推荐执行顺序 | PROJECT_DEF_V0.1 §2 |
| D-008 | 不包含缩小机制、新剧情、新迷宫、多人/联网 | ✅ 已确认 | 当前范围边界 | PROJECT_DEF_V0.1 §3.3 |
| D-009 | 不包含移动端适配和 GBA 原生移植 | ✅ 已确认 | 当前范围边界 | PROJECT_DEF_V0.1 §3.3 |
| D-010 | 样板目标体验长度：5—10 分钟 | 🔄 推荐默认 | 不是工期承诺 | PROJECT_DEF_V0.1 §4 |
| D-011 | 样板分两步交付：功能样板 → 风格样板 | ✅ 已确认 | 不并行，不先生产全地图美术 | PROJECT_DEF_V0.1 §4.2 |
| D-012 | 仓库根目录：`/home/ben/zelda-remake/` | ✅ 已确认 | @ben-gao 拍板 | P00 |
| D-013 | macmini02 为 headless 服务器，实际试玩需 @ben-gao 本地进行 | ✅ 已确认 | @ben-gao 拍板；录屏/截图反馈 | P00 |

---

## P00 环境盘点（@Cindy，已完成）

**机器**
- macmini02，Ubuntu 22.04（kernel 6.8.0-138-generic）
- 内存 15G（已用 2G），可用 13G；根分区 86G 可用
- 当前用户 `ben`，sudo / docker 组

**工具状态**
- ✅ git 2.34.1
- ❌ Godot（未安装；单文件 binary，下载即用）
- ❌ Solarus / ZQuest Classic（未安装）
- ✅ docker（组成员，待实际验证 daemon 可达性）

**网络状态**
- ✅ godotengine.org：可达，Godot binary 可下载
- ✅ gitlab.com：可达，Solarus 仓库可 clone
- ✅ Docker Hub：可达，docker pull 可用
- ❌ GitHub：超时，ZQuestClassic 等 GitHub 仓库无法直接 clone
- ❌ Google：超时，部分文档/CDN 受限

---

## 待确认事项（需 @ben-gao 决策）

| 编号 | 待确认项 | 阻塞内容 | 提出时间 |
|------|----------|----------|----------|
| O-001 | ~~仓库根路径：`/home/ben/zelda-remake/`~~ | ~~所有本地文件交付~~ | ✅ **已确认** |
| O-002 | ~~headless 服务器 + 本地试玩模式接受吗？~~ | ~~P01 收口~~ | ✅ **已确认** |
| O-003 | 引擎最终选定（Godot / ZQuest Classic / Solarus） | E02 实现启动 | V0.1 |
| O-004 | 样板画面比例、色彩和动画风格验收标准 | 风格样板交付 | V0.1 |
| O-005 | 服务器无直连外网，引擎/仓库获取方式（本地上传 / Docker 镜像 / 代理） | R01、scout 资源调研、E01 引擎验证 | P00（@general 发现，已细化） |

**O-005 细化（@Cindy 实测）：**
- ✅ Godot：官网可达，binary 可下载
- ✅ Solarus：GitLab 仓库可 clone
- ❌ ZQuest Classic（GitHub）：无法 clone，只能文档级核查
- ✅ Docker Hub：可达，镜像可 pull

---

## 版本记录

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| V0.1 | 2026-09-10 | 初始版本，从 PROJECT_DEF_V0.1 提取 |
| V0.2 | 2026-09-10 | 补充 P00 环境盘点结果，更新 O-001/O-002 待确认项 |

**O-005 最终细化（@general 实测，2026-09-10）：**
- ✅ godotengine.org HTML 可达（但 cdn.godotengine.org DNS 失败）
- ✅ api.github.com 可达（返回 JSON）
- ❌ objects.githubusercontent.com：超时，无法下载 release binary
- ❌ cdn.godotengine.org：不通
- ❌ Docker Hub 新镜像：代理 192.168.3.196:1080 不通
- ✅ 已缓存 Docker 镜像可用

**结论：Godot binary 必须由 @ben-gao 本地下载后上传到服务器。**

**O-005 进一步更新（@ben-gao 确认）：**
- macmini02 上 v2ray 已安装：binary `/tmp/v2ray`，HTTP 端口 1080，SOCKS5 端口 1096
- 节点：ss.bengao82.com (vmess)，监听 0.0.0.0
- 可通过 `export https_proxy=http://localhost:1080` 后用 curl/wget 下载 GitHub release

---

## P01 前置决策（@ben-gao 拍板，2026-09-10）

| 编号 | 决策内容 | 状态 | 依据 |
|------|----------|------|------|
| D-014 | 技术路线收紧：Godot 先验证，Solarus 保留备选，ZQuest 暂停深入核查 | ✅ 已确认 | P01 前期 |
| D-015 | 区分"网站可达"与"安装包可下载"、"引擎已装"与"可导出试玩版本" | ✅ 已确认 | P01 前期 |
| D-016 | general 首项交付：最小项目，能移动、能碰墙、能导出，用占位图形 | ✅ 已确认 | P01 前期 |
| D-017 | 试玩平台：Surface Pro 8，Win11 | ✅ 已确认 | @ben-gao |
| D-018 | 视觉风格：统一像素尺寸和缩放规则先定；色板/人物比例通过一屏场景比较后定 | ✅ 已确认 | P01 前期 |
| D-019 | 移动/攻击：四向移动+朝向刺击为暂定基线；速度/距离留待试玩调整 | ✅ 已确认 | P01 前期 |
| D-020 | 第一座迷宫：等开局样板验收通过后启动，不定具体日期 | ✅ 已确认 | P01 前期 |
| D-021 | v2ray 已安装：HTTP 1080 / SOCKS5 1096，节点 ss.bengao82.com | ✅ 已确认 | O-005 关闭 |

## 目录结构（最终版）

| 路径 | 用途 | 负责人 |
|------|------|--------|
| `src/project.godot` | Godot 项目入口 | @general |
| `src/scenes/` | 角色、场景、界面 | @general |
| `src/scripts/` | 游戏逻辑 | @general |
| `src/assets/` | 游戏用图片、音效、字体 | @general |
| `src/data/` | 关卡/敌人/道具配置 | @general |
| `art-source/` | 原始画稿、制作源文件 | 按任务 |
| `docs/` | 项目定义、决策日志、验收与运行说明 | @writer |
| `research/` | 调研报告、资源来源与使用条件 | @scout |
| `tools/` | 安装/运行/构建脚本 | @general |
| `.local/` | 本机引擎程序（不提交 Git） | @general |
| `builds/` | 导出试玩版本（不提交 Git） | @general |
| `README.md` | 项目入口、启动方法、当前状态 | @writer |
| `CONTRIBUTING.md` | 成员职责、提交与验收规则 | @Cindy + @writer |
| `.gitignore` | 排除缓存、本机工具和构建产物 | @general |

## 目录结构调整（@scout 建议，@ben-gao 采纳）

| 路径 | 用途 | 说明 |
|------|------|------|
| `.local/godot/` | Godot 引擎程序 | 不进 Git |
| `.local/tools/` | 本机辅助脚本 | 不进 Git |
| `builds/` | 导出试玩版本 | 不进 Git |
| `tools/` | 改为构建脚本 | 替代原"安装/运行" |
| `src/assets/` | 游戏用图片/音效/字体 | |
| `src/data/` | 关卡/敌人/道具配置 | |

**v2ray 启动验证（@Cindy 实测）：**
- 已手动启动 v2ray（pid 在跑），配置走 ss.bengao82.com vmess
- 直连 github.com 仍超时；加 `http_proxy=http://127.0.0.1:1080` 前缀后 GitHub release 下载成功、git clone 成功
- 使用方式：`export http_proxy=http://127.0.0.1:1080 https_proxy=http://127.0.0.1:1080 all_proxy=socks5://127.0.0.1:1096`
- 持久化方案待 @ben-gao 拍板（临时会话 / systemd 自启）

## E01/E02/P02 边界澄清（@ben-gao 拍板，2026-09-10）

| 项目 | 决策内容 | 状态 |
|------|----------|------|
| 引擎状态记录 | 记录为"Godot 已选定，安装与导出待验证"；验证成功前不标记技术验证完成 | ✅ 已确认 |
| E01 范围 | 安装 + 最小角色移动与碰墙 + Windows 导出（占位图形） | ✅ 已确认 |
| E02 范围 | E01 基础上增加取剑、战斗、场景切换、存档；再做风格升级 | ✅ 已确认 |
| P02 职责 | 仅负责 Surface 上的实际运行验收，复用 E01 导出包，不另做构建 | ✅ 已确认 |

## E01 进展（@general，2026-09-10）

**已完成**
- ✅ Godot 4.7.2 安装到 `.local/`（通过 v2ray 代理下载）
- ✅ 项目结构：`src/scenes/` `src/scripts/` `src/assets/` `src/data/`
- ✅ 林克角色：四向移动 + 碰墙检测 + 边界限制
- ✅ 主场景：玩家 + 左墙 + 右墙 + 地板（占位色块）
- ✅ Godot headless 验证通过
- ✅ Windows 导出配置 `export_presets.cfg` 已设置
- ✅ `.gitignore` 更新（排除 .local/ builds/ .godot/）

**阻塞中**
- ❌ Windows 导出模板（1.2GB）下载：v2ray 代理中途断开，需要稳定连接或 @ben-gao 本地导出

## E01 完成（@general，2026-09-10）

**最终交付**
- ✅ Godot 4.7.2 安装到 `.local/`
- ✅ 导出模板安装到 `~/.local/share/godot/export_templates/4.7.2.stable/`
- ✅ 林克四向移动 + 碰墙（`src/scripts/player.gd`）
- ✅ Windows x86_64 导出：`builds/zelda-prototype.exe`（105MB）
- ✅ 启动说明：`docs/RUN_INSTRUCTIONS.md`
- ✅ 源码 commit `f320973`

**用户验收**：Surface Pro 8 下载 `builds/zelda-prototype.exe`，双击运行，WASD/方向键移动，确认碰撞正常。

**GitHub 远程仓库（@ben-gao 配置）：**
- 仓库：https://github.com/nocooldog/FC-Zelda-remake
- 已 push 到 main 分支（commit 推送成功）
- 凭据通过 token（ghp_***）嵌入 URL

**v2ray 持久化（@ben-gao 配置）：**
- v2ray 已设为开机自启，无需手动启动

## E01 exe 分发
- `builds/zelda-prototype.exe`（105MB）在服务器 `/home/ben/zelda-remake/builds/`
- 仓库是私有的，GitHub release download URL 需要登录权限
- 获取方式：scp 从服务器拉，或 clone 后从本地 builds/ 目录取
- `docs/E01_report.md` 已 commit（`5d5be89`）
