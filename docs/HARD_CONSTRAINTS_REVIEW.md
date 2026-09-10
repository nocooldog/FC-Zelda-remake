# 硬约束复核（按 @ben-gao 2026-09-10 21:38 安排）

**复核人**：@scout
**复核时间**：2026-09-10
**复核依据**：R02 §6.4.3 4 条实现硬约束
**原则**：缺少复现证据的改为"待验证假设"

---

## 约束 1：玩家视觉用 `_draw()`

**原约束**：用 `player.gd` 的 `_draw()` 画矩形（不依赖 .tscn 序列化）

**复现证据**：
- ✅ E01 commit `3172d1e`（2026-09-10 10:51）：玩家 ColorRect 在 CharacterBody2D 下不可见
- ✅ 修复方案：删 player.tscn 的 ColorRect，加 `player.gd._draw()` 函数
- ✅ 后续 commit `6b0fa29`、`411619d`、v0.0.6 等多次回归验证：玩家方块可见（橙色/蓝色）
- **证据强度**：✅ 强（3 个 commit 反复验证）

**状态**：✅ **已确认约束**，保留。

---

## 约束 2：场景装饰 ColorRect

**原约束（V0.7 修正后）**：玩家节点（CharacterBody2D）下不挂 ColorRect；StaticBody2D 下挂 ColorRect 可用；若严格控制用 Polygon2D；v0.1.1 sword 必须 _draw()

**复现证据**：
- ✅ CharacterBody2D + ColorRect：E01 验证不可见（约束 1 的同源证据）
- ⚠️ StaticBody2D + ColorRect：v0.0.1-v0.1.3 用户反复测试看到墙/地板/洞穴入口（视觉正常），**但没有正面"修复测试"**——只观察到"删了不工作/留着能看见"
- ⚠️ sword 删 ColorRect 后 _draw()：**v0.1.1 合规章发现 sword 删了 ColorRect 但没补 _draw()，用户没看到剑**——但 @Cindy 后续说"剑能拾取"，**所以 v0.1.1 之后有没有补 _draw() 不知道**
- **证据强度**：⚠️ 中（仅"保留能工作 / 删除可能坏" 的负面证据，缺正面"删了改 _draw() 仍工作" 测试）

**状态**：⚠️ **部分待验证假设**——
- ✅ "CharacterBody2D + ColorRect = 不可见" — 已确认
- 🟡 "StaticBody2D + ColorRect 工作" — 仅负面证据（删了会坏）— **建议 v0.2 阶段做一次正面测试：删 WallL 的 ColorRect → 改 Polygon2D → 验证可见**
- 🟡 "sword 删 ColorRect + 补 _draw() 工作" — **v0.1.1 删了但没补**，v0.1.2/v0.1.3 没明说，**建议 v0.2 验证**

---

## 约束 3：菜单/UI 文字用像素字体

**原约束**：用 `Label` + 显式 `theme_override_fonts/font` 指定像素字体（如 Press Start 2P）

**复现证据**：
- ⚠️ v0.0.5 截图：菜单字体明显模糊/失真（用户 @ben-gao 反馈"菜单显示有问题"）
- ⚠️ v0.0.6 改用代码生成菜单：声称"代码生成，兼容 240×160"（@general 报告），**但用户仍报"菜单还是无法选中退出按钮"**（v0.1.0）
- ⚠️ v0.1.0 - v0.1.3：用户没再单独报字体问题（说明字体可能能看清了），但**没有正面截图/对比验证**
- ❓ **没有"修复"证据**——@general 报告说"代码生成"但没明说换了字体；R02 §6.4.3 建议"用 Label + 像素字体" 是否落地 **不清楚**
- **证据强度**：⚠️ 弱（无正面修复证据）

**状态**：🟡 **未确认约束（待验证假设）**——
- 假设"默认 Godot 字体在 viewport 缩放下失真"——理论上正确（失真原因：默认字体是 anti-aliased vector font，与像素艺术不匹配）
- 但**当前 v0.1.3 是否已显式指定像素字体**——**没有验证**
- 建议 v0.2 阶段验证：
  1. 检查 `src/scenes/menu.tscn` 或 `src/scripts/menu.gd` 是否有 `theme_override_fonts/font` 或 `FontFile` 引用
  2. 截图对比 v0.1.3 vs v0.0.5 字体清晰度
  3. 如果 v0.1.3 仍用默认字体，按约束加 `src/assets/fonts/PressStart2P.ttf` + Label 显式引用

---

## 约束 4：不要在 .tscn 写 position

**原约束**：StaticBody2D / CharacterBody2D 不要手动写 `position` 在 `.tscn` 里——通过 instance 父节点覆盖，或在 `_ready()` 里设

**复现证据**：
- ❓ **当前 v0.1.3 实际状态**：
  - `player.tscn` 写死 `position = Vector2(128, 112)` ⚠️
  - `main.tscn` instance 时 `position = Vector2(120, 140)` 覆盖 ✅
  - 但**main.tscn 自己也有 `position = Vector2(120, 140)`**（实际是被覆盖的子节点）
  - Wall/Floor/CaveEntrance 的 position 是必要属性（无 parent position 覆盖）
- ❌ **没有"不写 position 会出问题"的复现证据**——历史 bug（如开局玩家在错误位置）可能是 position 覆盖问题，**但没有显式 commit 标注根因**
- **证据强度**：❌ 极弱（无复现证据；属"防御性约束"）

**状态**：🟡 **未确认约束（防御性建议）**——
- 现状：position 在 .tscn 普遍使用（player.tscn、各 StaticBody2D），但都用 main.tscn 的 instance position 覆盖
- **没有发现实际 bug 来源于 .tscn 写 position**——这条约束可能过度防御
- 建议**降级**为"建议"而非"硬约束"：
  - 如果是 instanced scene（player 节点），position 由父节点覆盖，**.tscn 里写也行**（方便单独打开场景调试）
  - 如果是单一场景独有（墙/地板），position 必须写
  - 唯一要避免：position 在父 .tscn 和子 .tscn 都不写（变成 0,0，运行时位置错乱）

---

## 总结：4 条硬约束复核

| 约束 | 原措辞 | 复现证据 | 状态 | 建议 |
|---|---|---|---|---|
| 1 玩家 _draw() | 必须用 _draw() | ✅ 3 个 commit 反复验证 | ✅ 已确认 | 保留 |
| 2 装饰 ColorRect | CharacterBody2D 禁；StaticBody2D 可用；sword 必须 _draw() | ⚠️ 仅负面证据（删了会坏） | 🟡 部分待验证 | v0.2 阶段做正面测试 |
| 3 像素字体 | Label + theme_override_fonts/font | ❌ 无修复证据 | 🟡 待验证假设 | v0.2 检查 menu.gd/font 引用 |
| 4 不写 position | 不在 .tscn 写 position | ❌ 无复现证据 | 🟡 防御性建议 | 降级为"建议" |

**已确认**：1 条
**待验证假设**：3 条（约束 2 部分 / 约束 3 / 约束 4）

---

## v0.2 阶段建议（@ben-gao 安排）

1. **验证约束 2**：删 WallL 的 ColorRect → 改 Polygon2D → 验证仍可见
2. **验证约束 3**：检查 menu.gd / menu.tscn 是否有 `theme_override_fonts/font` 引用；如无，按 R02 §6.4.3 加 `src/assets/fonts/PressStart2P.ttf` + Label 显式引用
3. **降级约束 4**：从"硬约束"改为"建议"，写明 position 写法边界

---

## 给 @ben-gao 的结论

- **硬约束 #1 强证据保留**（_draw() 必须用）
- **硬约束 #2 部分弱证据保留**（v0.2 验证）
- **硬约束 #3 缺证据降为"待验证假设"**（v0.2 验证）
- **硬约束 #4 无证据降为"建议"**（删去"硬"字）
