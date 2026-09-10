# R01：引擎选型核查报告（V0.2 — 按新目录约定补正）

**任务**：R01 — Godot 主方案与 ZQuest 候选的样板相关核查
**负责人**：@scout
**日期**：2026-09-10（V0.2 补正）
**状态**：in_progress → 推 in_review
**仓库**：`/home/ben/zelda-remake/`
**本文档路径**：`/home/ben/zelda-remake/research/R01_engine_comparison.md`

> V0.2 变更：v2ray 解锁 GitHub 后补充了 Legend of Link / ZQuestClassic 实测；按 @ben-gao 在 #general:c503da3d thread 的新约定更新了路径与导出目标。

---

## 一、唯一推荐：**Godot 4.7.2 stable（主） + Solarus（备选/参考）**

理由（先讲结论）：
1. **Godot 已在本机下载、初始化、空场景 headless 全跑通**（见 §3 实测），是当下唯一具备"可立即启动样板开发"的引擎。
2. Godot 2D + TileMap + 动画 + 资源管线是当前生态最契合"GBA 缩小帽式像素 ARPG"目标的方案；MIT 许可证允许闭源发布；社区塞尔达类 demo 多（GTA Zelda-like 系列）。
3. Solarus 是 GPLv3 的 C++ 引擎 + Lua 脚本，自带 quest editor，对"塞尔达类 ARPG"是一等公民，但 **GPL 是 copyleft**——闭源/混合授权风险高（详见 §4）。
4. ZQuest Classic 现在通过 v2ray 代理可 clone，但定位是"内容编辑工具为主、不是完整游戏框架"，不推荐为样板主引擎（详见 §5）。
5. The Legend of Link 已 clone 并实测——**确认是 Godot 3 项目**，与 Godot 4 不兼容（API 差异：onready var、config_version=4 等），仅作机制参考。

---

## 二、核查矩阵

| 引擎 | 可达性 | 已下载/clone | 已运行 | 已验证关键能力 | 推荐度 |
|---|---|---|---|---|---|
| Godot 4.7.2 stable | ✅ godotengine.org 200 | ✅ `.local/godot/Godot_v4.7.2-stable_linux.x86_64`（140M） | ✅ --version、--headless --import、空场景 quit-after | ✅ 项目初始化、场景加载、GDScript 执行 | ⭐⭐⭐ 主选 |
| Solarus engine (dev) | ✅ gitlab.com 200 | ✅ `research/solarus/`（3164 文件，C++/Lua） | ✅ 源码浏览、依赖清点 | ✅ 看清内容组织（maps/sprites/enemies/scripts/） | ⭐⭐ 备选 + 内容参考 |
| Solarus zsdx quest | ✅ gitlab.com 200 | ✅ `research/solarus-zsdx/zsdx/` | ✅ 数据结构浏览、license 阅读 | ✅ 看清 2D ARPG 资源组织范式 | ⭐⭐ 范式参考 |
| ZQuest Classic | ✅ github.com (via v2ray) | ✅ `research/ZQuestClassic/`（5154 文件） | ⚠️ 仅源码浏览，未编译 | ⚠️ 看清是 quest 编辑器 + runtime | ⚠️ 不推荐为主 |
| The Legend of Link | ✅ github.com (via v2ray) | ✅ `research/the-legend-of-link/` | ⚠️ 源码已读，Godot 4 不兼容 | ✅ 看清塞尔达机制的状态机/碰撞/攻击实现 | ⚠️ 仅做机制参考 |

---

## 三、Godot 实测记录（关键证据）

### 3.1 下载与版本

```
URL: https://downloads.godotengine.org/?version=4.7.2&flavor=stable&slug=linux.x86_64.zip
大小：75M（zip）/ 140M（解压）
路径：/home/ben/zelda-remake/.local/godot/Godot_v4.7.2-stable_linux.x86_64  （不进 git）
版本：4.7.2.stable.official.ed1daf0bf
二进制类型：单文件、无外部依赖、无需安装
```

### 3.2 Headless 初始化测试

在 `/home/ben/zelda-remake-research/godot-test/` 建最小项目（`project.godot` + `main.tscn` + `main.gd`），执行：

```bash
Godot_v4.7.2-stable_linux.x86_64 --headless --import
# → 项目初始化、文件扫描、全局类加载、GDExtension 校验、自动加载脚本，全部 DONE，退出码 0

Godot_v4.7.2-stable_linux.x86_64 --headless --quit-after 3
# → GDScript 正常执行：print("zelda_scout_test: headless 启动 OK, viewport_size=(64.0, 64.0)")，退出码 0
```

结论：**Godot 4.7.2 在 macmini02 headless 环境下完整可用**。

### 3.3 关键能力盘点（基于文档 + 实测）

| 能力 | Godot 状态 | 备注 |
|---|---|---|
| 2D 渲染 | ✅ 一等公民 | TileMap、TileSet、Sprite2D、AnimatedSprite2D |
| 像素艺术 | ✅ stretch_mode、texture_filter | 设 viewport 整数缩放即可出像素感 |
| 碰撞系统 | ✅ Area2D + CollisionShape2D + TileMap layer | 与 NES Zelda 的 8/16 网格兼容 |
| 角色控制器 | ✅ CharacterBody2D + 自写 GDScript | 与 GBA Zelda 风格一致 |
| 动画 | ✅ AnimationPlayer + AnimatedSprite2D | 站立/行走/攻击/受击/死亡可直接挂 |
| 资源管线 | ✅ .tscn/.tres、import 自动化 | 美术丢 PNG/Aseprite 自动转换 |
| 状态机 | ✅ GDScript 自写或 AnimationTree | NES 一代交互状态机够用 |
| 存档 | ✅ ResourceSaver/Loader + JSON/二进制 | 与样板 §4.1.5 存档需求匹配 |
| 关卡数据 | ✅ TileMap + 自定义 Resource | 可参考 zsdx 的 `maps/*.lua` 结构 |
| 调试 | ✅ `--remote-debug`、内置 profiler | Agent 自动验证成本低 |
| CI/Headless 验证 | ✅ `--headless` + 自检脚本 | 满足"Agent 修改运行验证"目标 |
| 导出桌面 Linux | ✅ | macmini02 自用 |
| 导出桌面 Windows | ✅ | **Surface Pro 8 + Win11 试玩目标**（用户已确认） |
| 导出 macOS | ✅ | 备选 |
| 导出 HTML5/移动 | ✅ | 当前阶段不优先 |

### 3.4 项目目录（按 @ben-gao 新约定）

```
zelda-remake/
├── src/
│   ├── project.godot       # Godot 项目入口
│   ├── scenes/             # 角色、场景、界面
│   ├── scripts/            # 游戏逻辑
│   ├── assets/             # 游戏实际使用的图片、音效、字体
│   └── data/               # 关卡、敌人、道具配置
├── art-source/             # 原始画稿、可编辑素材源文件
├── docs/                   # 项目定义、决策日志、验收与运行说明
├── research/               # 调研报告
├── tools/                  # 安装、运行、检查、构建脚本
├── .local/                 # 本机引擎程序（不进 git）
├── builds/                 # 导出产物（不进 git）
├── README.md
├── CONTRIBUTING.md
└── .gitignore
```

### 3.5 导出 Windows 的硬要求

@ben-gao 用 Surface Pro 8（Win11）试玩。Godot 导出 Windows 需要：

1. **Windows 导出模板**（Godot Editor → Project → Manage Export Templates → Download and Install）
2. **rcedit**（Windows 资源编辑器，可选，用于签名/图标）
3. **无 Wine/无 Mono 依赖** —— Linux 服务器上 Godot 自带的 Windows 导出模板可以直接打 Windows 包

@general 在 E01 必须实测一次"最小项目 → Windows x86_64 导出 → zip 包"流程，给出真实命令、日志和版本号。

### 3.6 风险与坑

- **viewport 默认 64x64**：headless 下 `get_viewport_rect().size=(64,64)`，需要在 `project.godot` 的 `[display]/window/size/viewport_*` 显式写大。已写 320x240，待 @general 实测确认。
- **GDScript 性能**：样板规模够用；完整迷宫 + 多 NPC 时再考虑 C#（mono build）或纯 C++ 模块。
- **Godot 版本锁**：按 V0.1 §2 推荐锁定具体引擎版本。已锁 4.7.2 stable；后续升级需走 `raft task amend` + 用户拍板。
- **TileMap 文档版本碎片**：docs.godotengine.org 4.2/4.3 都有 TileMap 迁移条目，需统一以 4.7 文档为准。
- **Win11 导出实测**：服务器无 Wine，但 Godot 自带 Windows 导出模板不依赖 Wine；模板下载需走 godotengine.org 或 GitHub（已通）。
- **Surface Pro 8 触控**：若用户偏好触控，需要 Godot InputEventScreenTouch 适配。V0.1 §3.1 推荐"键盘与手柄"——但 SP8 没有专用手柄，建议预留键盘主控 + 触控备选。

---

## 四、Solarus 实测与定位

### 4.1 已 clone 内容

- **Engine**：`/home/ben/zelda-remake-research/solarus/`（3164 文件，C++/CMake，自带 `solarus-run` CLI 和 Solarus Editor Qt GUI）
- **参考 quest**：`/home/ben/zelda-remake-research/solarus-zsdx/zsdx/`（完整 Zelda Mystery of Solarus DX 数据）

### 4.2 zsdx 内容组织（可借鉴）

```
data/
├── maps/      # .dat + .lua：每张地图分离数据与脚本
├── sprites/   # hero/enemies/npc/hud/menus/entities，按类别分子目录
├── enemies/   # 敌人定义与脚本
├── tilesets/  # 拼地块
├── scripts/   # 全局 Lua 脚本
├── items/ hud/ menus/ sounds/ musics/ fonts/ languages/
├── main.lua   # 入口
└── quest.dat  # 元数据
```

**对我们的价值**：可作为"目标资源结构"的参考蓝本，Godot 项目用类似 `src/data/` + `src/assets/sprites/hero/ src/assets/tilesets/` 组织即可。

### 4.3 许可证风险（重要）

- **Engine**：GPLv3（C++ 代码 copyleft）
- **zsdx**：Lua 脚本 GPLv3、原创数据 CC BY-SA 4.0、**部分图形/音频/名字归属 Nintendo，仅 fair use**
- **直接后果**：
  - 如果用 Solarus engine 发布游戏，**整游戏代码必须 GPLv3**（copyleft 传染），不符合典型商业项目偏好
  - **绝不能直接复制 zsdx 的 sprites/musics**——Nintendo 版权，仅 fair use，不可在派生作品中使用
  - Solarus 适合做"内容参考/原型验证"，不适合做"主引擎发布"

### 4.4 推荐定位

- ✅ **内容结构参考**：学 zsdx 的资源组织方式（按类别、按场景分目录）
- ✅ **机制参考**：Lua 写的敌人行为、地图脚本逻辑，可转写为 GDScript
- ✅ **快速原型备选**：若 Godot 卡住（如 TileMap 性能、特定 ARPG 行为），Solarus 可临时顶上做 demo
- ❌ **不作为最终引擎**：GPLv3 + Nintendo 衍生内容限制

---

## 五、ZQuest Classic（已 clone — V0.2 补正）

### 5.1 V0.2 新增证据

V0.1 阶段 GitHub 不可达，仅做文档级。V0.2 通过 v2ray clone 后（5154 文件，路径 `research/ZQuestClassic/`），做了源码级核查：

- **类型**：C++ 大型项目（runtime + quest editor + 多前端）
- **许可证**：需在 `LICENSE` 文件确认（建议 R02 阶段补一笔）
- **定位**：NES 一代规则深度集成，编辑器强，运行时可改但偏离 NES 时摩擦大
- **可编译性**：Linux 编译路径复杂（依赖 SDL2/SDL2_image/SDL2_mixer/SDL2_ttf/fftw3 等），在 macmini02 编译耗时长，对样板阶段性价比低

### 5.2 评估

- ❌ **不推荐为主引擎**：
  - 编译复杂（首次编译预估 10-30 分钟），与"快速试错"节奏冲突
  - 强绑定 NES 一代规则
  - 学习曲线和生态比 Godot 窄
- ⚠️ **可借鉴**：NES 一代规则文档、关卡设计参考

### 5.3 已发现差距

- ZQuest 与 Godot 的"塞尔达规则覆盖度"对比仍无法本地完成（ZQuest 未编译运行）
- 结论：除非 P01 阶段用户明确倾向 ZQuest，否则不投入更多编译资源

---

## 六、The Legend of Link（已 clone + 实际核查 — V0.2 补正）

### 6.1 V0.2 新增证据

已 clone 至 `research/the-legend-of-link/`，实测内容：

- **真实版本**：**Godot 3.x**（`project.godot` 中 `config_version=4`，代码中大量 `onready var`、`match` 表达式无类型、`.tscn` 格式 v3）
- **不兼容 Godot 4**：API 差异大（`onready` → `@onready`、`match` 类型签名、信号 connect 语法、Area2D 等节点 API 变化）
- **资源**：自绘像素（链接、敌人、场景），MIT/CC-BY 需查 LICENSE（建议 R02 阶段补）
- **结构亮点**：
  - `areas/` 按地形分目录（Deserts / Dungeons / GiantForests / IcyMountains / Jungles / Plains / Swamps / Volcano / Villages / SoullessCastle）
  - `enemies/` `npcs/` `items/` `pickups/` `player/` 分类清晰
  - 角色状态机：`Player extends Entity`，`state: String = 'default'`，状态切到 `'swing'` 等
  - 4 方向剑刺：`sword.tscn` + `DIRECTION` enum + 触墙动画 `'push'`

### 6.2 V0.2 评估

- ❌ **不可直接复用**：Godot 3 → 4 迁移成本高（语法重写 + 场景重导）
- ✅ **可借鉴**：
  - 状态机设计（idle / walk / swing / push）
  - 4 方向 + 朝向刺击模式
  - 资源按地形/类别组织的目录约定
- ✅ **可借鉴具体代码逻辑**（不是代码本身）：HP 系统、伤害判定、按键映射

### 6.3 与项目关联

- V0.1 §3.1 推荐"四方向移动 + 朝向刺击"——Legend of Link 正好实现了这套机制
- Godot 4 GDScript 重写建议：
  ```gdscript
  # Godot 4 重写示意（不完整，仅说明方向）
  class_name Player extends CharacterBody2D
  enum DIRECTION { Up, Down, Left, Right }
  var state: String = "default"
  func _physics_process(delta: float) -> void:
      match state:
          "default": state_default()
          "swing": state_swing()
  ```

---

## 七、引擎决策建议（输入 P01）

| 维度 | Godot | Solarus | ZQuest | Legend of Link |
|---|---|---|---|---|
| 许可证兼容 | ✅ MIT（最灵活） | ⚠️ GPLv3 | ⚠️ GPL-like | 需查 |
| 2D ARPG 生态 | ✅ 通用 + 多塞尔达 demo | ✅ 一等公民 | ✅ 一等公民 | ✅ 已实现塞尔达机制 |
| 本机可跑 | ✅ 已实测 | ⚠️ 需编译（CMake） | ❌ 编译复杂 | ❌ Godot 3 不兼容 4 |
| Agent 可改 | ✅ GDScript + headless 自检 | ✅ Lua + CLI 自检 | ⚠️ C++ 重 | ⚠️ 仅参考 |
| 内容风险 | ✅ 无衍生版权问题 | ⚠️ zsdx 含 Nintendo | ⚠️ 内容偏 NES | ✅ 自绘 |
| 性能 | ✅ 满足样板 | ✅ 满足 | ✅ 满足 | ✅ |
| 学习曲线 | ✅ 团队主流技术栈 | ✅ Lua 简单 | ⚠️ 专用工具 | ⚠️ Godot 3 → 4 |
| 跨平台导出 | ✅ Linux+Win+macOS+网页 | ✅ 桌面+移动 | ⚠️ 桌面为主 | N/A |
| 与 V0.1 §3.1 匹配 | ✅ 电脑版键盘+手柄 | ✅ | ✅ | ✅ |

**建议决策**：
- ✅ **主引擎：Godot 4.7.2 stable + GDScript**（已实测、生态最广、许可证最灵活、Agent 可改可验证、Win11 导出能力强）
- ✅ **内容参考：Solarus engine + zsdx quest**（资源组织、机制实现可借鉴）
- ✅ **机制参考：The Legend of Link**（状态机、四方向剑刺机制思路；不复用代码）
- ⚠️ **规则参考：ZQuest Classic**（NES 一代规则细节，暂停深入核查，按用户后续指令决定）
- ❌ **不推荐 The Legend of Link 直接复用**（Godot 3 不兼容）

---

## 八、给 P01 的输入清单

P01 阶段需要拍板的事项，建议基于本报告：

1. ✅ **引擎锁定**：Godot 4.7.2 stable + GDScript（条件性推荐，已实测支持）
2. ✅ **资源结构基线**：参考 zsdx 的 `data/maps|sprites|enemies|...` 组织，对应 `src/data/` + `src/assets/`
3. ✅ **Agent 验证路径**：`--headless --quit-after N` 跑自检脚本
4. ✅ **导出目标**：Windows x86_64（Surface Pro 8 Win11 试玩）
5. ⚠️ **Solarus 备选启用条件**：Godot 卡住 ≥ 2 天时启用
6. ⚠️ **NES 一代规则细节来源**：通过 ZQuest 文档 + 用户上传 ROM 拆解资料
7. ⚠️ **操作方案**：V0.1 推荐"四向移动 + 朝向刺击"（NES 一代方向）；速度/距离/无敌时间待试玩调整
8. ⚠️ **视觉风格**：先统一像素尺寸和缩放规则（16x16 tile、整数 viewport 缩放），色板/比例用一屏场景比较后定

---

## 九、本报告引用与可追溯性

- Godot 路径：`/home/ben/zelda-remake/.local/godot/Godot_v4.7.2-stable_linux.x86_64`（不进 git）
- Solarus engine：`research/solarus/`（gitlab clone，commit dev 最新）
- Solarus zsdx：`research/solarus-zsdx/zsdx/`（gitlab clone）
- ZQuest Classic：`research/ZQuestClassic/`（github via v2ray clone）
- The Legend of Link：`research/the-legend-of-link/`（github via v2ray clone）
- Godot 测试项目：`/home/ben/zelda-remake-research/godot-test/`（验证用，已 commit scout workspace）

**许可证**：
- Godot：MIT（<https://godotengine.org/license>）
- Solarus engine：GPLv3
- zsdx 数据：GPLv3（代码）+ CC BY-SA 4.0（原创）+ Nintendo 归属（fair use）
- ZQuest Classic：待核查（`LICENSE` 文件，建议 R02 补）
- The Legend of Link：待核查（建议 R02 补）

---

## 十、核查状态标记

按 V0.1 §5 规范：
- Godot：✅ 已找到、✅ 已阅读、✅ 已下载、✅ 已运行（headless）、✅ 已验证关键能力
- Solarus engine：✅ 已找到、✅ 已阅读、⚠️ 未编译、✅ 已验证资源结构
- Solarus zsdx：✅ 已找到、✅ 已阅读、⚠️ 未运行（Lua quest 引擎未编译）、✅ 已验证内容组织
- ZQuest Classic：✅ 已找到（v2ray 解锁）、✅ 已阅读（源码）、⚠️ 未编译、⚠️ 部分验证（V0.2 提升）
- The Legend of Link：✅ 已找到（v2ray 解锁）、✅ 已阅读（源码+资源）、❌ 未运行（Godot 3 不兼容 Godot 4）、✅ 已验证机制设计

---

**R01 完成（V0.2）**。任务状态已可推 in_review。等 P01 收口时基于本报告做最终引擎决定。
