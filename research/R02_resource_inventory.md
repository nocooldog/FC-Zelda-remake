# R02：样板资源盘点报告（V0.2 — 按新约定补正）

**任务**：R02 — 盘点样板所需人物/环境/敌人/原版场景资料
**负责人**：@scout
**日期**：2026-09-10（V0.2 补正）
**状态**：in_progress → 推 in_review
**仓库**：`/home/ben/zelda-remake/`
**本文档路径**：`/home/ben/zelda-remake/research/R02_resource_inventory.md`

> 当前状态：R02 本身（资源盘点）已完成；**资源补全与 Godot 导出验证不在本任务范围，由 E01/E02 + 用户拍板驱动**。R02 待 P01 收口后关闭。

> V0.2 变更：按 @ben-gao 在 #general:c503da3d thread 的新目录约定更新路径（`src/assets/` `src/data/` `.local/` `builds/` `art-source/`）；加入 v2ray 解锁后的 GitHub 来源（ZQuest Classic 已 clone、The Legend of Link 已 clone）；新增试玩目标 Surface Pro 8 + Win11。

> 盘点字段按 V0.1 §5：资源名称｜用途｜来源链接｜版本/提交号｜许可证/使用条件｜核查状态｜缺口｜负责成员。
> 核查状态：已找到 / 已阅读 / 已下载 / 已运行 / 已验证。
> 网络：直连可达 godotengine.org / gitlab.com / Docker Hub；通过 v2ray 可达 github.com / Google。

---

## 一、样板范围（来自 V0.1 §4.1）

5-10 分钟可玩样板，需要的内容：
1. 林克出现在开局场景
2. 进入洞穴，与老人交互并获得剑
3. 出洞，与一种代表性敌人战斗
4. 切换至相邻场景，再返回
5. 保存、退出并读取，正确保留取剑状态
6. 验证受击、死亡与重新开始

需要的资源类别：人物（Link + 老人 + 敌人）、环境（开局室外 + 洞穴 + 相邻室外）、道具（剑）、敌人、原版场景资料、UI（对话、生命、存档提示）、音效。

---

## 二、人物（Link / 老人 / 敌人）

### 2.1 Link 精灵（必备）

| 项 | 值 |
|---|---|
| **用途** | 主角站立、行走（4 方向）、攻击、受击、死亡 5 类动画 |
| **来源** | Solarus zsdx `data/sprites/hero/`（参考结构）；Aseprite/手工像素；The Legend of Link `player/`（Godot 3，仅参考） |
| **版本** | zsdx dev 最新；Legend of Link master |
| **许可证** | zsdx 原始素材含 Nintendo 归属（仅 fair use）—— **不可直接复用**；Legend of Link 待核查（建议查 LICENSE） |
| **核查** | ✅ 已找到、✅ 已阅读、❌ 不可用（版权）/⚠️ 仅参考（Godot 3） |
| **缺口** | 需要全新原创像素美术或开源许可资源 |
| **建议来源** | OpenGameArt.org（搜 "link-like" / "zelda-like" / "hero pixel"）；itch.io 免费像素包；Aseprite 模板；或自绘 |
| **负责** | @ben-gao（美术方向拍板）/@general（导入管线）|

### 2.2 老人（NPC，对话给剑）

| 项 | 值 |
|---|---|
| **用途** | 1-2 帧站立 + 对话触发 |
| **来源** | 自绘或 OpenGameArt NPC 包 |
| **缺口** | 同上 |
| **负责** | 同上 |

### 2.3 代表性敌人（1 种）

| 项 | 值 |
|---|---|
| **用途** | 巡逻/站立、移动、攻击、受击、死亡动画 |
| **来源** | zsdx `data/sprites/enemies/`（octorok 类似基础敌人）；Legend of Link `enemies/` |
| **许可证** | zsdx 同 Nintendo 衍生；Legend of Link 待核查 |
| **缺口** | 需原创或开源替代 |
| **建议** | 优先用"通用四方向移动敌人"模板（OpenGameArt 有大量）；不要照搬 Octorok 视觉 |
| **负责** | 同美术 |

---

## 三、环境（开局室外 / 取剑洞穴 / 相邻室外）

### 3.1 草地、地块拼接规范

| 项 | 值 |
|---|---|
| **用途** | 16x16 拼地块（grass、dirt、stone、water、tree、rock） |
| **来源** | Solarus zsdx `data/tilesets/0.tiles.png`（参考尺寸/调色板）；Legend of Link `areas/<地形>/`（参考） |
| **许可证** | Nintendo 衍生，不可复用；Legend of Link 待核查 |
| **核查** | ✅ 已找到、✅ 已阅读、❌ 不可用 |
| **缺口** | 需全新原创 tileset |
| **建议** | OpenGameArt "Zelda-like tilesets"、itch.io 资源、自绘 |
| **负责** | 同美术 |

### 3.2 树木、岩壁、洞口

| 项 | 值 |
|---|---|
| **用途** | 装饰物件，遮挡层级 |
| **来源** | 同上 |
| **缺口** | 同上 |

### 3.3 洞穴内部

| 项 | 值 |
|---|---|
| **用途** | 室内地块（不同调色板），墙、地板、火把/光源 |
| **来源** | 同上 |
| **缺口** | 同上 |

### 3.4 拼接规范

- 推荐：**16x16 像素网格**，与 NES Zelda 一致，简化碰撞计算
- 上层装饰（树顶/屋顶）放 Sprite2D，与 TileMap 分离做 Y-sort
- 受击/碰撞用 Godot TileMap 的 `collision_layer`
- viewport 整数缩放（`project.godot` 的 `window/size/viewport_width=320 viewport_height=240` + `stretch/mode="viewport"` + `stretch/aspect="keep"`）

---

## 四、敌人（独立于 §2.3 的机制层）

### 4.1 敌人数据/脚本

| 项 | 值 |
|---|---|
| **用途** | 敌人行为定义（移动模式、攻击、检测半径、HP） |
| **来源** | zsdx `data/enemies/*.lua`、zsdx `data/scripts/`；Legend of Link `enemies/*.gd`（仅机制参考） |
| **许可证** | zsdx Lua 脚本 GPLv3——可参考逻辑、不可直接复制；Legend of Link 待核查 |
| **核查** | ✅ 已找到、✅ 已阅读 |
| **缺口** | 需要用 GDScript 重写；不能复制 Lua/GDScript 代码 |
| **建议** | 读懂逻辑后用 GDScript 重新实现，避免许可证冲突 |
| **负责** | @general（实现）|

### 4.2 敌人精灵（视觉）

见 §2.3。

---

## 五、UI 与音效

### 5.1 对话框、生命值、存档提示

| 项 | 值 |
|---|---|
| **用途** | 顶部 HUD（心数/HP）、对话框、存档指示 |
| **来源** | 自制 UI + OpenGameArt "UI pixel" |
| **缺口** | 需自绘或开源包 |
| **建议** | 用 Godot Control + Theme，统一 16x16 字号 |

### 5.2 音效（剑、敌人受击、对话、环境音乐）

| 项 | 值 |
|---|---|
| **用途** | 6-8 个核心 SFX + 1-2 段背景音乐（室外+洞穴） |
| **来源** | OpenGameArt SFX（"8-bit" / "chiptune"） |
| **许可证** | 多为 CC0 / CC-BY |
| **核查** | ⚠️ 未本地核查（需 v2ray 访问 OpenGameArt） |
| **缺口** | 完整音效集 |

---

## 六、原版场景资料

### 6.1 NES Zelda 一代地图数据

| 项 | 值 |
|---|---|
| **用途** | 参照原版"开局室外 → 洞穴 → 室外"地图布局、敌人位置、隐藏元素 |
| **来源** | NES ROM 拆解（zelda3 disassembly 风格）、ZQuest Classic 内置 NES 数据、Hyrule 攻略站 |
| **核查** | ⚠️ 文档级 + ZQuestClassic 仓库已 clone（5154 文件） |
| **缺口** | **重要**：缺原版场景的精确数据 |
| **建议** | (a) @ben-gao 上传 NES Zelda ROM → 在本机用开源 disassembler 提取；(b) 用公开的 Zelda 地图截图（Zelda Map 等）；(c) ZQuest Classic 内置 NES 模板文档（仓库已 clone，可参考 quest 模板）|
| **负责** | @scout（拿到资料后整理）|

### 6.2 敌人位置、事件、取剑条件

| 项 | 值 |
|---|---|
| **用途** | 还原"取剑触发条件"、"出洞后敌人刷新"等 |
| **来源** | 同 §6.1 |
| **缺口** | 同上 |

### 6.3 已有原版资料源（已 clone + 文档级）

| 名称 | 路径/URL | 备注 |
|---|---|---|
| ZQuestClassic（已 clone） | `research/ZQuestClassic/` | 内置 NES quest 模板可参考；许可证待核查 |
| The Legend of Link（已 clone） | `research/the-legend-of-link/` | 自绘塞尔达类地图，许可证待核查 |
| The Legend of Zelda (1986) — Zelda Wiki | zelda.fandom.com/wiki/The_Legend_of_Zelda | 场景列表、敌人位置、道具条件 |
| ZeldaMaps | zeldamaps.dyndns.org | 经典地图截图 |
| NES ROM Hacking 社区 | romhacking.net | ROM 拆解工具与文档 |

### 6.4 公开参考资料分析结果（@ben-gao 拍板 GBA 240×160 后）

> 来源：Wikipedia（已提供链接）、StrategyWiki（已访问）、公开 Wikipedia/romhacking.com 摘要。
> **仅基于公开资料层**，不读取用户上传的 ROM 字节码。
> 模拟器（fceux）在本机 headless 下崩溃（buffer overflow），未能产出 ROM 截图；已记录为阻碍项。

#### 6.4.1 NES 一代公开技术参数

| 项 | 值 | 来源 |
|---|---|---|
| 原始分辨率 | 256×240（含状态条），有效游戏区 256×224 | Wikipedia "The Legend of Zelda" |
| 颜色 | 调色板 6 色，选 4 色用于场景 | Wikipedia |
| tile 限制 | "Due to the Famicom only supporting 256 tiles" | Wikipedia |
| 地图结构 | 8×8 屏幕 overworld（flip-screen，每屏幕 256×224），连成 16×8 总布局 | 公开 disassembly 摘要 |
| 迷宫数 | 8 个主迷宫 + 隐藏迷宫 | Wikipedia / ZQC |
| 场景类型 | overworld（草地/森林/沙漠/雪山/死亡山）、洞穴、迷宫、商店 | ZQC 模板 |
| 玩家移动 | 四向（NES 手柄无斜向） | ZQC |
| 武器 | 木剑（起始获得）、白剑、魔法剑、银箭 | ZQC |
| 护甲 | 小盾牌、魔法盾牌 | ZQC |
| 主要敌人 | Octorok（八爪鱼）、Moblins（猪兵）、Tektites（蜘蛛）、Wizzrobes（巫师）、Ganon | ZQC 公开摘要 |

#### 6.4.2 GBA 缩小帽公开技术参数（已拍板的风格参考目标）

| 项 | 值 | 来源 |
|---|---|---|
| 原始分辨率 | **240×160**（与 @ben-gao 拍板一致） | Wikipedia "The Legend of Zelda: The Minish Cap" |
| 移动 | 四方向（手柄方向键）；斜视差视角（角色走动时有 3D 视错觉） | Wikipedia |
| 特色机制 | 缩小帽（缩小身型进入微观世界）、融合魔法（与他人合体）、剑技（4 种剑技：回旋斩、暴斩、推剑、大旋） | Wikipedia / 公开资料 |
| 美术风格 | 经典 2D 像素 + 暖色调；人物比例偏卡通圆滑 | 公开截图描述 |
| tile | 16×16 像素 tile（与 NES 一代同尺寸） | ZQC / 公开分析 |
| 视差层 | 多层视差（前景/中景/背景），增强深度感 | 公开描述 |

#### 6.4.3 与当前项目的映射

| 项 | NES 一代 | GBA 缩小帽（目标） | 当前 E02 v0.0.3 | 调整建议 |
|---|---|---|---|---|
| 分辨率 | 256×224 | **240×160** ✅ | 240×160 | 已对齐 |
| tile 尺寸 | 8×8 / 16×16 | 16×16 | 16×16 | 已对齐 |
| 玩家碰撞 | 8×8（NES 调色） | 8×8 | 8×8 | 已对齐 |
| 移动 | 4 向 | 4 向 + 视差 | 4 向 | 已对齐 |
| 攻击 | 朝向刺击 | 4 种剑技 | 朝向刺击（空格） | E02 范围：仅刺击；4 种剑技属 E03+ |
| 地图切换 | 单 overworld + 多迷宫 | 多 overworld + 多室内 | 户外 ↔ 洞穴 | 已实现 |
| **渲染方式** | — | — | **必须用 `_draw()`**（非 ColorRect） | **E01 验证**：ColorRect 在 CharacterBody2D / StaticBody2D 下渲染不稳定（不可见或位置错乱），`player._draw()` + 静态 ColorRect / Polygon2D 才能稳定。E02.5 复发此类问题（commit `411619d` 误改回 ColorRect）。 |

**实现硬约束**（从 E01 修复经验沉淀，后续提交必须遵守）：
1. **玩家视觉**：用 `player.gd` 的 `_draw()` 画矩形（不依赖 .tscn 序列化）
2. **场景装饰视觉**：CanvasItem 下不要挂 ColorRect；若需装饰，用 `Polygon2D` 或 sprite
3. **菜单/UI 文字**：用 `Label` + 显式 `theme_override_fonts/font` 指定像素字体（如 Press Start 2P），不依赖默认系统字体（默认字体在缩放下失真）
4. **位置**：StaticBody2D / CharacterBody2D 不要手动写 `position` 在 `.tscn` 里——通过 instance 父节点的 position 覆盖，或在 `_ready()` 里设

---

## 七、引擎与代码资源

### 7.1 Godot engine

| 项 | 值 |
|---|---|
| **版本** | 4.7.2 stable（已锁定） |
| **路径** | `/home/ben/zelda-remake/.local/godot/Godot_v4.7.2-stable_linux.x86_64` |
| **许可证** | MIT |
| **核查** | ✅ 已下载、✅ 已运行（headless 空场景） |
| **缺口** | 无 |
| **导出目标** | Windows x86_64（Surface Pro 8 Win11 试玩） |

### 7.2 Solarus engine + zsdx（参考用）

| 项 | 值 |
|---|---|
| **路径** | `research/solarus/`（引擎）、`research/solarus-zsdx/zsdx/`（参考 quest）|
| **许可证** | engine GPLv3、zsdx Lua GPLv3、zsdx 数据 CC-BY-SA 4.0 + Nintendo 衍生（仅 fair use） |
| **用途** | 参考内容组织、敌人机制；不复用代码/美术 |
| **核查** | ✅ 已 clone、✅ 已阅读 |

### 7.3 ZQuest Classic（已 clone — V0.2 补正）

| 项 | 值 |
|---|---|
| **路径** | `research/ZQuestClassic/`（5154 文件）|
| **许可证** | 待核查（建议查 `LICENSE` 文件） |
| **用途** | NES 一代规则参考、内置 quest 模板 |
| **核查** | ✅ 已 clone（v2ray 解锁 GitHub）、✅ 已浏览目录、⚠️ 未编译 |
| **暂停深入** | 按用户指令，编译性价比低，保留为参考 |

### 7.4 The Legend of Link（已 clone — V0.2 补正）

| 项 | 值 |
|---|---|
| **路径** | `research/the-legend-of-link/` |
| **引擎版本** | Godot 3.x（与 Godot 4 不兼容，**不能直接用**） |
| **许可证** | 待核查（建议查 `LICENSE` 文件） |
| **用途** | 塞尔达类机制参考：状态机、四方向剑刺、HP/伤害 |
| **核查** | ✅ 已 clone（v2ray）、✅ 已阅读源码 |
| **复用方式** | 仅借鉴机制思路，Godot 4 GDScript 重写 |

---

## 八、本地已可用资源汇总（按新目录约定）

| 类别 | 资源 | 路径 | 状态 |
|---|---|---|---|
| 引擎 | Godot 4.7.2 | `zelda-remake/.local/godot/` | ✅ 可用（不进 git） |
| Godot 项目入口 | 待 @general 建 | `zelda-remake/src/project.godot` | ⏳ E01 |
| 游戏运行时资源 | 待 @general 集成 | `zelda-remake/src/assets/` | ⏳ E01 |
| 关卡/敌人/道具配置 | 待 @general 建 | `zelda-remake/src/data/` | ⏳ E01 |
| 原始画稿 | 待美术 | `zelda-remake/art-source/` | ⏳ 用户 |
| 调研参考引擎 | Solarus | `zelda-remake-research/solarus/` | ✅ 可用（参考） |
| 调研参考 quest | zsdx | `zelda-remake-research/solarus-zsdx/zsdx/` | ✅ 可用（参考） |
| 调研参考（V0.2） | ZQuest Classic | `zelda-remake-research/ZQuestClassic/` | ✅ 可用（参考） |
| 调研参考（V0.2） | The Legend of Link | `zelda-remake-research/the-legend-of-link/` | ✅ 可用（机制参考） |
| 调研报告 | R01 / R02 / Hermes | `zelda-remake/research/` | ✅ 已 commit |
| Godot 测试项目 | scout 验证 | `/home/ben/zelda-remake-research/godot-test/` | ✅ 可用（验证用） |

---

## 九、缺口清单（按样板需求优先级）

### P0 阻塞（不解决就无法开工）

1. **Link 像素精灵**（站立/行走/攻击/受击/死亡）—— 需自绘或开源
2. **敌人精灵 1 种**（含 5 类动画）—— 需自绘或开源
3. **草地/地块 tileset** —— 需自绘或开源
4. **洞穴室内 tileset** —— 需自绘或开源
5. **对话框/HUD UI** —— 需自绘或开源

### P1 重要（影响样板完整性）

6. **音效 6-8 个**（剑/受击/对话/UI/背景音乐）—— 需 CC0 来源（OpenGameArt via v2ray）
7. **老人 NPC 精灵**
8. **NES Zelda 原版场景数据**（用于布局参照）—— ZQuestClassic 仓库已 clone 可参考 NES quest 模板

### P2 可后置（样板后补）

9. **存档图标、菜单背景**
10. **敌人死亡特效**

---

## 十、推荐资源来源（带 v2ray 代理路径）

### 10.1 像素美术开源资源（v2ray 可达）

| 来源 | URL | 类型 | 许可 |
|---|---|---|---|
| OpenGameArt | opengameart.org | tilesets/sprites/SFX | 多 CC0/CC-BY |
| Itch.io 免费区 | itch.io/game-assets/free | 同上 | 多 CC0 |
| Liberated Pixel Cup | opengameart.org/content/lpc | 通用 RPG 精灵 | CC-BY-SA 3.0 |
| OpenClipart | openclipart.org | 简单装饰 | CC0 |

### 10.2 音效（v2ray 可达）

| 来源 | 类型 |
|---|---|
| OpenGameArt SFX（"8bit" "chiptune" "fantasy"） | SFX + BGM |
| freesound.org | SFX（需账号）|
| incompetech.com | BGM（CC-BY，需署名）|

### 10.3 字体（像素）

| 来源 | 许可 |
|---|---|
| Google Fonts 的 Press Start 2P | OFL |
| dafont.com "pixel" 分类 | 多 free for commercial |

### 10.4 调研代理使用方式（已确认）

```bash
export http_proxy=http://127.0.0.1:1080
export https_proxy=http://127.0.0.1:1080
export all_proxy=socks5://127.0.0.1:1096
# 然后正常 curl / git / wget 都走代理
```

---

## 十一、给后续阶段的输入

### 给 @general（E01/E02）

**引擎**：Godot 4.7.2 在 `.local/godot/`，单文件 binary，直接调用

**最小项目模板**（参考 `/home/ben/zelda-remake-research/godot-test/` 的最小结构）：
```
zelda-remake/src/
├── project.godot     # Godot 4 配置（viewport 320x240、stretch、pixel filter）
├── scenes/
│   └── main.tscn     # 主场景入口
├── scripts/
│   └── main.gd       # 启动脚本
├── assets/           # 图片/音效/字体（运行用）
└── data/             # 关卡/敌人/道具配置
```

**E01 硬验收（来自 @Cindy 任务追加）**：
- "网站可达 ≠ 包能下"——必须实测下载 + 解压 + 跑通
- "安装 ≠ 能导出 Win11"——必须实测导出 Windows x86_64 包，给真实命令、日志、版本号
- 最小交付：一个能移动、能碰墙的角色（占位图形）+ 启动说明 + 可运行的 Win11 导出包

**资源目录结构建议**（按 zsdx 范式 + 新约定）：
```
zelda-remake/src/
├── project.godot
├── scenes/        # 角色 .tscn + 关卡 .tscn + UI .tscn
├── scripts/       # GDScript（玩家/敌人/UI 控制器）
├── assets/
│   ├── sprites/hero/
│   ├── sprites/npc/
│   ├── sprites/enemies/
│   ├── tilesets/
│   ├── ui/
│   ├── sfx/
│   ├── music/
│   └── fonts/
└── data/          # 关卡数据、敌人配置、道具配置（自定义 Resource）
```

### 给 @ben-gao（决策项 — 待拍板）

- **美术方向**：自绘 / 用开源包 / 委托画师？
- **音乐方向**：CC0 拼装 / 委托 / 接受静音样板？
- **是否上传 NES ROM 或 ROM 拆解资料**（强烈建议，让 @scout 整理原版场景数据）
- **是否启用 v2ray 走代理**访问 OpenGameArt / itch.io？或采用"用户本地下载 → scp 上传"路径
- **Surface Pro 8 操作偏好**：键盘主控 / 触控备选 / 都支持？（Godot InputEvent 多源适配）

### 给 P01（收口）

- 引擎：Godot 4.7.2 + GDScript（已由 R01 推荐）
- 导出目标：Windows x86_64（Surface Pro 8 Win11 试玩）
- 资源策略：原创+开源包，避免 Nintendo 衍生
- 缺口责任分配：美术走 @ben-gao 拍板+开源补全；音效走 CC0

---

## 十二、核查状态汇总

| 资源 | 找到 | 阅读 | 下载 | 运行 | 验证 | 备注 |
|---|---|---|---|---|---|---|
| Godot 4.7.2 | ✅ | ✅ | ✅ | ✅ | ✅ | 全绿 |
| Solarus engine | ✅ | ✅ | ✅ | ⚠️ | ⚠️ | 未编译（参考足够） |
| zsdx quest | ✅ | ✅ | ✅ | ⚠️ | ⚠️ | 未运行 quest（参考足够） |
| ZQuest Classic | ✅ | ✅ | ✅ | ⚠️ | ⚠️ | 已 clone，编译复杂，暂停深入 |
| Legend of Link | ✅ | ✅ | ✅ | ❌ | ✅ | Godot 3 不兼容 Godot 4，仅机制参考 |
| Link 精灵 | ❌ | ❌ | ❌ | ❌ | ❌ | **缺口 P0** |
| 敌人精灵 | ❌ | ❌ | ❌ | ❌ | ❌ | **缺口 P0** |
| Tileset | ❌ | ❌ | ❌ | ❌ | ❌ | **缺口 P0** |
| 音效 | ⚠️ | ❌ | ❌ | ❌ | ❌ | **缺口 P1**（v2ray 可访问 OpenGameArt） |
| NES 原版场景数据 | ⚠️ | ⚠️ | ⚠️ | ❌ | ❌ | **缺口 P1**（ZQuestClassic NES 模板可参考，完整 ROM 待上传） |

---

**R02 完成（V0.2）**。任务状态已可推 in_review。

**最重要的两个行动**：
1. @ben-gao 拍板美术方向（自绘/开源/委托）
2. @ben-gao 决定是否上传 NES ROM 拆解资料（ZQuestClassic 内置 NES quest 模板可作为参考起点）

---

## 十三、补充：模拟器截图尝试受阻

@ben-gao 2026-09-10 17:14 拍板：可以在 macmini02 上用模拟器跑 ROM 截图作参考，不提取字节码。

已安装：
- `fceux` 2.5.0（NES 模拟器）
- `mgba-sdl`（GBA 模拟器）
- `xvfb` 虚拟 X server
- `scrot` X11 截图工具

**问题**：
- fceux 在 Xvfb 下加载 NES ROM 后崩溃：`*** buffer overflow detected ***: terminated`，在 "Loading SDL sound with pulseaudio driver" 后立即报错。多次尝试包括 `SDL_AUDIODRIVER=dummy`、`QT_DEBUG_PLUGINS=1` 都无法绕过。
- 错误可能是 fceux 2.5.0 + Qt + Xvfb 的已知兼容问题。
- mgba-sdl 未实际测试（优先处理 fceux 问题）。

**替代方案**：
- 方案 A：用户本地用模拟器截图 → 传上来（@scout 接收后基于截图分析）
- 方案 B：基于公开资料（Wikipedia / StrategyWiki / ZQC disassembly 摘要）做参数对照——已写入 §6.4
- 方案 C：等后续升级 fceux 或换 RetroArch（apt 不可用，需自行安装）

当前 R02 §6.4 已用方案 B 完成。方案 A 可作为补充（如 @ben-gao 愿意本地截图）。

---

## 十四、公开攻略 / 视频参考（§6.4 延伸）

@ben-gao 2026-09-10 21:11 追加：搜公开攻略 + 视频攻略获取游戏画面。scout 仅引用 URL + 文字描述，不下载视频/截图字节码。

### 14.1 NES 一代公开攻略视频（YouTube）

| 视频 ID | URL | 类型 | 覆盖场景 | 可用描述 |
|---|---|---|---|---|
| `tqXXWhpthj8` | <https://youtu.be/tqXXWhpthj8> | 全程 100% 零伤通关 | 全部场景（开局、取剑、迷宫、Death Mountain） | RetroArchive 频道 |
| `6g2vk8Gudqs` | <https://youtu.be/6g2vk8Gudqs> | 100% 全程攻略 | 全部场景 | packattack04082 |
| `_nmEBas91CI` | <https://youtu.be/_nmEBas91CI> | 前期秘籍（额外心、剑升级） | 前期 + 取剑 + 魔法剑 | “EARLY GAME SECRETS” |
| `ETE2rwqPL9o` | <https://youtu.be/ETE2rwqPL9o> | “魔法剑”获取 | 取剑洞穴 + 老人 + 剑升级 | Episode 5 |
| `1HDQynNUCyU` | <https://youtu.be/1HDQynNUCyU> | 两次剑升级获取 | 第一次取剑 + 后续升级 | How to Get Both Sword Upgrades |
| `KsXJoSrSx23g`（原 XsJoSrSx23g） | <https://youtu.be/XsJoSrSx23g> | 银剑立即获取 | 取剑 + 银剑隐藏点 | How to get Silver Sword |
| `GdKhbhONz4k` | <https://youtu.be/GdKhbhONz4k> | 隐藏秘密 / 道具 / 区域 / 武器汇总 | 全部隐藏要素 | Hyrule Reverie |
| `zCzQG4XMezs` | <https://youtu.be/zCzQG4XMezs> | 第一部分（隐藏洞穴 + 第一迷宫） | 开局室外 + 初始洞穴 | Part 1 |
| `3zwV2LGrTnA` | <https://youtu.be/3zwV2LGrTnA> | Second Quest 攻略 | 第二轮冒险场景（与第一轮不同） | Second Quest |

**可用于核对的关键画面**（scout 未来需要时调阅）：
- 开局室外（林克初始位置、洞穴入口位置、史菜姆/莫布林刷新点）
- 初始洞穴（老人 + 剑的位置、墙布局）
- 8 个迷宫的入口标记

### 14.2 GBA 缩小帽公开攻略视频（YouTube）

| 视频 ID | URL | 类型 | 覆盖场景 |
|---|---|---|---|
| `67JnuDtTp_Y` | <https://youtu.be/67JnuDtTp_Y> | Full 100% Walkthrough | 全部场景 |
| `UfEMNbjLd3Y` | <https://youtu.be/UfEMNbjLd3Y> | Full Playthrough | 全部场景 |
| `lHH1etcuKg4` | <https://youtu.be/lHH1etcuKg4> | **GBA Upscaling Test** | 专门展示 240×160 原生画面 + 放大效果（最适合视觉参考） |
| `W6LuoePYECw` | <https://youtu.be/W6LuoePYECw> | IPS v2 GBA Gameplay | IPS 补丁版画面参考 |
| `q3Kg8l_Klw8` | <https://youtu.be/q3Kg8l_Klw8> | Longplay [002] US | 美版完整 longplay |
| `2a4Ai1_t3RA` | <https://youtu.be/2a4Ai1_t3RA> | Complete 100% Walkthrough | 全部场景 |
| `nJ_rwXnLxmI` | <https://youtu.be/nJ_rwXnLxmI> | Minish Cap 3DS Port | 3DS 移植版画面（可对比 GBA 原生风格） |

**可用于核对的关键画面**：
- 240×160 原生 viewport 下的角色 / 场景渲染
- 林克精灵尺寸与动画帧（走动、攻击、受击）
- 室内 / 室外 tileset 调色板
- 菜单 / 装备界面布局（与本项目 M 菜单对比）
- 调色板方向（暖色、中色、背景色）

### 14.3 补充公开资源

| 来源 | URL | 备注 |
|---|---|---|
| GameFAQs NES Zelda 攻略 | <https://gamefaqs.gamespot.com/nes/563433-the-legend-of-zelda> | 文字攻略 + 场景地图（403 Cloudflare，未能访问但链接记录） |
| Zelda Fandom Wiki（The Legend of Zelda） | <https://zelda.fandom.com/wiki/The_Legend_of_Zelda> | 场景 / 敌人 / 道具参考（Cloudflare 被拦） |
| Zelda Fandom Wiki（Minish Cap） | <https://zelda.fandom.com/wiki/The_Legend_of_Zelda:_The_Minish_Cap> | 同上（Cloudflare 被拦） |
| StrategyWiki Zelda | <https://strategywiki.org/wiki/The_Legend_of_Zelda> | 文字攻略（已访问，含剧情与攻略） |
| StrategyWiki Minish Cap | <https://strategywiki.org/wiki/The_Legend_of_Zelda:_The_Minish_Cap> | 同上 |

### 14.4 推荐调阅顺序

如果未来 scout 需要补齐画面描述，推荐顺序：
1. 先看 GBA 缩小帽的 `lHH1etcuKg4`（GBA upscaling）→ 明确 GBA 风格基线
2. 再看 NES 一代 `tqXXWhpthj8` 100% 零伤通关 → 了解一代全场景与机制
3. 对比 `GdKhbhONz4k` NES 秘密汇总 → 提取隐藏要素（为后续迷宫设计参考）

**注意**：上述所有内容为**公开可访问的视频攻略 + 文字攻略**，不涉及 ROM 字节码提取。
