# 硬约束复核（v0.2.2 版，依据当前 HEAD 实际源码）

**复核人**：@scout
**复核时间**：2026-09-11
**复核依据**：R02 §6.4.3 4 条实现硬约束
**当前 HEAD**：v0.2.2（commit `939fbb1`，pck sha `3156eb01`）
**对照版本**：v0.1.3 → v0.2 → v0.2.1 → v0.2.2

> **与 v0.1.3 版复核（commit `60ed084`）的差异**：本次复核对当前 HEAD v0.2.2 **实际源码**做"文字 - 代码 - 行为"三重核对，而不是只看历史 commit。结论上 4 条约束的状态有变化，详见下文。

> **复核原则**（@ben-gao 21:38）：缺少复现证据的改为"待验证假设"；有正面证据的标"已确认"。

---

## 约束 1：玩家视觉用 `_draw()`

**§6.4.3 原文**：用 `player.gd` 的 `_draw()` 画矩形（不依赖 .tscn 序列化）

**当前 v0.2.2 源码核对**：
- ✅ `src/scripts/player.gd::_draw()` 函数存在（行 51–63），**根据 `has_sword` 切换颜色**：
  ```gdscript
  var color = Color(0.4, 0.7, 1.0, 1.0) if has_sword else Color(1.0, 0.5, 0.0, 1.0)
  draw_rect(Rect2(-4, -4, 8, 8), color)
  ```
- ✅ `src/scenes/player.tscn`：**无 ColorRect 子节点**（仅 CharacterBody2D + CollisionShape2D + script）
- ✅ 攻击态 `_draw()` 也画白矩形（行 56–63）

**正面复现证据**（多次 commit 反复验证）：
- `3172d1e`（E01 闪退修复）：ColorRect 临时回归 → 后删除
- `6b0fa29`（Polygon2D 替代 Sprite2D+ColorRect）：玩家不可见 → Polygon2D 修复
- `db9629a`（E02.5）：玩家改为 `_draw()` 绘制，删 player.tscn ColorRect
- `c9c040a`（v0.2 锁版）+ `126fe6e`（v0.2.1 清理）：玩家节点稳定用 `_draw()`
- 用户验收（22:01）："好像拿到剑了"——玩家变蓝 = `has_sword=true` → `_draw()` 切色 → 视觉确认

**证据强度**：✅ 强（commit 链 + 当前源码 + 用户视觉验收三重印证）

**状态**：✅ **已确认约束**，保留。

---

## 约束 2：场景装饰 ColorRect

**§6.4.3 V0.7 原文**：
> **玩家节点**（CharacterBody2D）下不要挂 ColorRect。StaticBody2D 下挂 ColorRect 实际工作（墙/地板/洞穴入口可用），若需严格像素控制优先用 Polygon2D 或 sprite。v0.1.1 进一步验证：sword 删 ColorRect 后**必须**补 `_draw()`。

**当前 v0.2.2 源码核对**（所有 .tscn 文件）：

| 节点 | 父节点类型 | 视觉方式 | §6.4.3 合规？ |
|---|---|---|---|
| `main.tscn::WallL.ColorRect` | StaticBody2D | ColorRect | ✅（§6.4.3 明文允许） |
| `main.tscn::WallR.ColorRect` | StaticBody2D | ColorRect | ✅（同上） |
| `main.tscn::Floor.ColorRect` | StaticBody2D | ColorRect | ✅（同上） |
| `main.tscn::CaveEntrance.ColorRect` | Area2D | ColorRect | ✅（Area2D 非 CharacterBody2D，§6.4.3 未明确，按 StaticBody2D 同等处理） |
| `cave.tscn::WallL/R/Floor.ColorRect` | StaticBody2D | ColorRect | ✅ |
| `cave.tscn::CaveExit.ColorRect` | Area2D | ColorRect | ✅ |
| `cave.tscn::OldMan.ColorRect` | StaticBody2D | ColorRect | ✅ |
| `slime.tscn::ColorRect`（root） | CharacterBody2D | ColorRect | ✅（slime 是敌人，**不是玩家节点**——§6.4.3 仅限制"玩家节点"） |
| `player.tscn` 无 ColorRect | CharacterBody2D | `_draw()` | ✅（由约束 1 覆盖） |
| `sword.tscn`（v0.1.1 后） | Area2D | 无视觉（玩家拿剑后隐藏，由 player 攻击动画代显示） | ✅（sword 不需视觉，仅作拾取触发器） |

**正面复现证据**：
- `6128403`（v0.1.1 合规章检查）：发现 sword 删 ColorRect 但没补 `_draw()` 导致剑不可见——这是"删了必须补"的反面证据
- `db9629a`（E02.5）：玩家恢复 `_draw()` 绘制后，玩家不再依赖 .tscn ColorRect
- 用户验收（22:01）：进洞能拿剑、出洞能打史莱姆 = 剑 + 史莱姆 ColorRect 渲染都正常

**未验证 / 弱证据**：
- 🟡 "玩家 CharacterBody2D 节点下 ColorRect 不可见"——这条只在 E01 早期 `6b0fa29`/`3172d1e` 出现过，且 `3172d1e` 又**回退到 ColorRect**（"闪退修复"），意味着 ColorRect 在 E01 后其实可用。**§6.4.3 V0.7 措辞实际是基于 v0.1.1 经验的事后总结，并非正面"删 ColorRect 不可见"复现测试**

**证据强度**：🟡 中（§6.4.3 当前形式在 v0.2.2 完全合规；但"玩家 CharacterBody2D 禁 ColorRect"这条原始假设缺正面复现证据，更像"经验共识"而非"实验结论"）

**状态**：🟡 **当前合规（v0.2.2 源码满足 §6.4.3 文字）；原始假设缺正面复现证据**。

**建议**：
1. §6.4.3 V0.7 措辞可保留（已避开歧义，明确"玩家节点"）；不需要进一步修改
2. 想要"正面证据"——可做一次 `v0.2+` 测试：在临时分支把 player.tscn 改回 ColorRect，看是否仍可见（**不推荐**，会回到 E01 闪退风险）
3. 当前合规，无需改动 v0.2.2 源码

---

## 约束 3：菜单/UI 文字用像素字体

**§6.4.3 原文**：用 `Label` + 显式 `theme_override_fonts/font` 指定像素字体（如 Press Start 2P），不依赖默认系统字体（默认字体在缩放下失真）

**当前 v0.2.2 源码核对**（grep 全项目）：
- ❌ `theme_override_fonts`：**0 处引用**
- ❌ `FontFile` / `.ttf` / `.otf`：**0 处引用**
- ❌ `src/assets/` 目录：**不存在**（无字体资产）
- ⚠️ `add_theme_font_size_override` 大量使用（menu.gd 行 51/59/65/77/85/91/116/126/131 等），但**只设字号，不设字体**——继承 Godot 默认 anti-aliased vector font
- ⚠️ `menu.tscn`（autoload，但 menu.gd 用 `_build_ui()` 完全覆盖 .tscn 结构）：Label 也只用 `theme_override_font_sizes`
- ⚠️ `src/project.godot` 无 `[gui_theme]` / `font` 默认配置

**正面复现证据**：
- ✅ 假设"默认字体在缩放下失真"——理论上成立（默认 Godot 4 font 是 anti-aliased vector）
- ❌ **"必须用像素字体"未实现**——v0.2.2 没有 `.ttf`、没有 `theme_override_fonts`、没有 font asset

**反证 / 弱化证据**：
- 🟡 @general 7 步验收清单没列字体——可能 v0.2.2 试玩时字体**用户没报问题**（或 font_size=10/11 在 240×160 + F2/F3 缩放下不算严重失真）
- 🟡 STATUS.md 推迟项：「菜单像素字体 → v0.2+」（未实现已记录）

**证据强度**：❌ **约束在 v0.2.2 未实现**（不是"待验证假设"，是"确认未满足"）

**状态**：🟡 **约束未实施（v0.2.2 不满足）**——非复现证据问题，是实现缺失问题。

**建议**：
1. 这是**实现债**，不是"待验证假设"——需要在 v0.3+ 落实：
   - 加 `src/assets/fonts/PressStart2P.ttf`（开源，OFL）
   - `project.godot` 加 `[gui_theme]` default font 引用
   - 或 `menu.gd::_build_ui()` 每个 Label 加 `add_theme_font_override("font", preload("res://assets/fonts/PressStart2P.ttf"))`
2. D02「已知问题」需明确列出："菜单字体未使用像素字体（§6.4.3 约束 3 未实现）"
3. v0.2.2 验收时**不阻塞**（@ben-gao 21:38 拍板"不扩大范围"）

---

## 约束 4：StaticBody2D/CharacterBody2D 不在 .tscn 写 position

**§6.4.3 原文**：StaticBody2D / CharacterBody2D 不要手动写 `position` 在 `.tscn` 里——通过 instance 父节点的 position 覆盖，或在 `_ready()` 里设

**当前 v0.2.2 源码核对**（grep 所有 .tscn）：

| .tscn | 节点 | position 写法 | §6.4.3 文字合规？ |
|---|---|---|---|
| `player.tscn` | Player (root) | `Vector2(128, 112)` | ❌ 文字违规 |
| `main.tscn` | Player (instance) | `Vector2(120, 140)` | ❌ 文字违规 |
| `main.tscn` | Slime (instance) | `Vector2(180, 100)` | ❌ 文字违规 |
| `main.tscn` | WallL.CollisionShape2D | `Vector2(4, 80)` | ❌ 文字违规 |
| `main.tscn` | WallR.CollisionShape2D | `Vector2(236, 80)` | ❌ 文字违规 |
| `main.tscn` | Floor.CollisionShape2D | `Vector2(120, 156)` | ❌ 文字违规 |
| `main.tscn` | SwordSpawn (Node2D) | `Vector2(80, 130)` | ❌ 文字违规（虽然是 Node2D，但 §6.4.3 只列 CharacterBody2D/StaticBody2D） |
| `main.tscn` | CaveEntrance.CollisionShape2D | `Vector2(120, 4)` | ❌ |
| `cave.tscn` | Player, SwordSpawn, Wall*, Floor, CaveExit | 多处 `position =` | ❌ 文字违规 |
| `slime.tscn` | Slime (root) | `Vector2(200, 112)` | ❌ 文字违规 |

**所有 .tscn 都在写 position**——这是项目**普遍模式**，不是个别违规。

**正面复现证据（约束是否成立）**：
- ❌ **无任何 bug commit 把根因归于".tscn 写 position"**（git log 全搜过：colorrect/polygon/draw 相关 5 个 commit，无一涉及 position 写入）
- ✅ §6.4.3 文字意图——"通过 instance 父节点覆盖"——v0.2.2 实际就是这样：player.tscn 默认 `(128, 112)`，main.tscn instance 时覆盖 `(120, 140)`（覆盖生效，STATUS.md 玩家边界 clamp 6–234 / 6–154 正常工作）
- 🟡 **"position 在 .tscn 会出错"**——找不到复现证据。E01 闪退 commit (`3172d1e`) 改的是 gravity_scale 和 ColorRect，跟 position 无关

**证据强度**：❌ **约束文字与实际行为不符**——文字写"不要写"，但项目普遍在写；项目普遍写但不出问题

**状态**：🟡 **建议降级 + 重新措辞**——
- 当前 §6.4.3 措辞有歧义：到底是"绝对不要写"还是"父节点要覆盖"？
- 项目实际模式：被实例化的 .tscn 写 position 作**默认值**，父 .tscn 用 instance 时**覆盖**——这正是 §6.4.3 想表达的"实例化场景 position 由父 .tscn 决定"
- 但字面文字确实禁止一切 .tscn position 写法——与项目实际不符

**建议措辞改写**（v0.3 R02 §6.4.3 V0.8）：
> **位置**：被实例化的 .tscn 里 CharacterBody2D/StaticBody2D 节点的 `position` 应视为**默认值**（方便单独打开该场景调试）；运行时实际位置由 instance 父 .tscn 的 position 覆盖决定。**不要在 _ready() 里硬编码 position**——那样会覆盖父节点设定，造成"instance 父节点改位置无效"的隐性 bug。

---

## 总结：v0.2.2 4 条硬约束复核

| 约束 | 原措辞 | v0.2.2 实际源码 | 复现证据 | 状态 |
|---|---|---|---|---|
| 1 玩家 _draw() | 必须用 _draw() | ✅ 已实现（player.gd::_draw() 含 has_sword 分支） | ✅ 强（多 commit + 用户视觉验收） | ✅ **已确认** |
| 2 装饰 ColorRect | 玩家 CharacterBody2D 禁；StaticBody2D 可；sword 必须 _draw() | ✅ 完全合规（玩家用 _draw；slime 用 ColorRect 但非玩家节点） | 🟡 中（§6.4.3 文字合规，但"玩家 CharacterBody2D 禁 ColorRect"原始假设缺正面复现） | 🟡 **当前合规，假设弱** |
| 3 像素字体 | Label + theme_override_fonts/font | ❌ 未实现（0 处引用、无字体资产） | ❌ 无实现证据 | ❌ **未实施（实现债）** |
| 4 不写 position | 不在 .tscn 写 position | ❌ 文字违规（项目普遍写） | ❌ 无 bug commit 把根因归于 position 写法 | 🟡 **建议降级 + 重新措辞** |

**状态分布**：
- ✅ 已确认：1 条（约束 1）
- 🟡 合规但假设弱 / 需重新措辞：2 条（约束 2、约束 4）
- ❌ 未实施（实现债）：1 条（约束 3）

---

## v0.3+ 阶段建议

1. **约束 3（像素字体）**：v0.3 实施
   - 加 `src/assets/fonts/PressStart2P.ttf`
   - `project.godot` 加 `[gui_theme]` default font，或 menu.gd 每个 Label 加 `add_theme_font_override`
   - D02「已知问题」列出此未实现项
2. **约束 4 措辞**：R02 §6.4.3 升 V0.8，按本文"建议措辞改写"重写
3. **约束 2** 不动（§6.4.3 V0.7 已足够清晰，v0.2.2 完全合规）

---

## v0.2.2 验收不阻塞依据

@ben-gao 21:38 拍板："**不扩大范围**，优先核心闭环"。本次复核确认：
- 约束 1 已实现且用户已验收（取剑变蓝 = `has_sword=true` → `_draw()` 切色）
- 约束 2 v0.2.2 合规
- 约束 3、约束 4 是**实现债 + 措辞问题**，不影响当前核心闭环（新游戏 → 取剑 → 出洞 → 击杀 → 重开持剑）

**v0.2.2 7 步验收可以走，约束 3/4 留 v0.3+ 处理。**

---

## 与 v0.1.3 版复核（commit `60ed084`）的差异

| 项 | v0.1.3 版（`60ed084`） | v0.2.2 版（本文） |
|---|---|---|
| 复核方法 | 仅看历史 commit + 状态推断 | 直接读 v0.2.2 实际源码（`.gd` + `.tscn` + `project.godot`） |
| 约束 1 状态 | ✅ 已确认 | ✅ 已确认（用户 22:01 视觉验收强化） |
| 约束 2 状态 | 🟡 部分待验证 | 🟡 合规但假设弱（措辞层面已足够） |
| 约束 3 状态 | 🟡 待验证假设 | ❌ **未实施**（明确为实现债，不是"假设未验证"） |
| 约束 4 状态 | 🟡 防御性建议 | 🟡 **建议降级 + 重新措辞**（项目普遍模式与文字不符） |
| 给 D02 的输入 | 模糊（"待验证"） | 明确（约束 3 是实现债、约束 4 是措辞问题） |

---

## 维护记录

- **v0.1.3 版**（commit `60ed084`，2026-09-10 21:38）：基于历史 commit 推断
- **v0.2.2 版**（本文，2026-09-11）：基于实际源码核对 + 用户视觉验收（22:01）
- **下次复核**：v0.3 锁版后 / 约束 3 实施后
