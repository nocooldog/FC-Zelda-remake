# P01 选型决策记录

**完成日期**：2026-09-10
**负责人**：@Cindy
**状态**：✅ 已拍板（@ben-gao 在 #general 推进 P01 收口）

本文档汇总 R01 + R02 + E01 + E02 的证据，做最终选型决策。引用所有支撑报告。

---

## 1. 引擎锁定

### 决策
**Godot 4.7.2 stable + GDScript**

### 依据
- **R01 引擎核查报告** (`research/R01_engine_comparison.md`)：
 - ✅ Godot 已下到本地、headless 跑通空场景
 - ✅ MIT 许可证（允许闭源发布）
 - ✅ 2D/TileMap/动画/像素艺术生态完整
 - ⚠️ Solarus（备选）GPLv3 + zsdx 含 Nintendo 衍生内容，不**不适合主发布
 - ⚠️ ZQuest Classic 仅文档级核查（GitHub 不可达）
- **E01 验证**：实际导出 Win11 x86_64（109MB exe），用户试玩成功
- **E02 验证**：实现完整样板（洞穴 + 户外 + 史莱姆 + 剑 + 场景切换 + 存档）

### 备选启用条件（仅在 Godot 卡 ≥2 天时考虑）
- Solarus：GPLv3 风险，引擎 + zsdx 参考

---

## 2. 资源结构

### 决策
**对齐 Solarus zsdx 的资源组织范式**：

```
src/
├── scenes/        # Godot 场景（.tscn）
├── scripts/       # GDScript 逻辑（.gd）
├── assets/        # 游戏素材（图片、音效、字体）
├── data/          # 关卡 / 敌人 / 道具配置
└── project.godot  # 项目入口
```

### 依据
- R02 资源盘点：zsdx 是被验证的 2D ARPG 资源组织范式
- E02 实现已落地（cave.tscn + overworld.tscn + slime.tscn + sword.tscn）
- 美术与音效后续从 OpenGameArt / Itch.io / Liberated Pixel Cup 等获取

---

## 3. Agent 验证路径

### 决策
**Headless 自动验证 + 人工 Surface Pro 8 试玩双重路径**：

- **Headless 自检**（@general 跑）：
 - `godot --headless --path src --quit-after N`（快速冒烟）
 - 命令行直接跑 exe 捕获崩溃日志（避免双击闪退看不到错误）
- **Surface Pro 8 试玩**（@ben-gao）：
 - 下载 exe + pck 同目录运行
 - 用 docs/PLAYTESTING.md §5 清单验收

### 关键教训（来自 E01 修复过程）
- **Godot 缓存会导致打包内容陈旧**：每次重新打包前 `rm -rf ~/.local/share/godot/app_userdata/<project_name>` + `rm -rf builds/`
- **PCK 重新打包后必须验证 sha256 是否真的变了**
- **git commit 后的源码 ≠ pck 中的代码**（可能差一个 commit）

---

## 4. 样板参数定稿

### 已确定（来自 E01 + E02 实现）

| 项 | 值 | 依据 |
|---|---|---|
| 引擎 | Godot 4.7.2 stable | R01 + E01 |
| 语言 | GDScript | R01 |
| 渲染 | 2D（CanvasItem / CharacterBody2D / StaticBody2D） | E01 + E02 |
| 视口 | 256×224 NES 风格（可放大到 4x/8x 显示） | E01 |
| 帧率 | 60 FPS（Godot 默认 `_physics_process` 频率） | 默认 |
| 玩家碰撞体 | 8×8 RectangleShape2D（CharacterBody2D） | E01 修复后 |
| 玩家视觉 | 12×12 橙色 ColorRect / Polygon2D | E01 修复后 |
| 移动 | 四向（WASD / 方向键），归一化方向向量 × 80 px/s | E01 |
| 存档 | `user://save.dat`（Godot 用户目录），场景状态 + 取剑状态位 | E02 |
| 场景切换 | Area2D `body_entered` 信号触发 | E02 |
| 敌人 | 史莱姆（Octorok 替代，左右巡逻） | E02 |
| 攻击 | 空格键，朝向刺击 | E02 |

### 留待风格样板阶段拍板（V0.1 §3.2 + §4.3）

- **视觉风格细节**：
 - 色板方向（GBA 缩小帽参考）
 - 人物尺寸 vs 原版比例
 - 动画帧率 / 流畅度
 - UI 字体（Press Start 2P 推荐，OFL）
- **移动/攻击参数**（§3.3 强调不要直接搬缩小帽）：
 - 攻击距离 / 持续时间
 - 无敌时间
 - 刺剑 vs 挥剑（用哪个？）
- **第一座迷宫**：等风格样板验收通过后再启动

---

## 5. 待用户拍板项（不阻塞样板）

### 高优先级（风格样板前需要）
1. **美术来源**：自绘 / 开源素材 / 委托？（R02 推荐 OpenGameArt / Itch.io 免费区起步）
2. **像素尺寸**：保留 256×224 NES 风格，还是放大到 GBA 风格的 240×160？

### 中优先级（可推迟）
3. **音效库选型**：incompetech / OpenGameArt chiptune / 自制？
4. **NES ROM 拆解**：是否上传用于参考一代规则（V0.1 §5 列了"使用条件"待确认）
5. **窗口放大选项**：Surface Pro 8 上看着小，是否提供 2x/3x 缩放？

### 已暂搁
6. **第一座迷宫启动时机**：等风格样板验收后
7. **公开版本 / 商业发布**：暂不在样板阶段考虑

---

## 6. 任务表更新

- ✅ P01（本文档）：选型决策记录完成
- ⏭️ E02 已上传 v0.0.2（@general 直接发布，详见 commit `34af161`）
- ⏭️ D02 待 E02 试玩反馈后启动（运行说明 / 变更记录）
- ⏭️ A01 样板验收：等用户完成 E02 完整试玩（取剑 / 战斗 / 切图 / 存档）

---

## 7. 引用

- [R01 引擎选型核查](research/R01_engine_comparison.md) — commit `1fd3e73` + 多次更新
- [R02 资源盘点](research/R02_resource_inventory.md) — commit `70b04b2` + 更新
- [E01 报告](docs/E01_report.md) — commit `5d5be89`
- [E02 报告（待 @general 补）](#) — 应包含 cave/overworld 场景切换、敌人 AI、存档路径
- [V0.1 项目定义](docs/PROJECT_DEF_V0.1.md) — commit `04c6608`
- [决策日志](docs/DECISIONS.md) — 持续维护

---

## 8. 版本记录

| 版本 | 日期 | 内容 |
|---|---|---|
| V1.0 | 2026-09-10 | 选型收口（Godot 4.7.2 + GDScript + 资源结构 + Agent 验证路径），样板参数定稿，留待风格样板阶段拍板项 |