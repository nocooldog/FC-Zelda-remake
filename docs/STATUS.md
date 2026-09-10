# 功能状态总览（STATUS）

> **状态三态**：
> - 🟡 **已写代码** — 源码中存在实现，commit 在仓，未运行过
> - 🟠 **已运行验证** — 本地 headless / 测试 exe 在 macmini02 跑通过
> - 🟢 **用户已验收** — Surface Pro 8 / Win11 实机试玩通过

> **关联 commit**：首次实现该功能的 commit（或最近修复）
> **关联 pck**：首个含该功能且通过对应验证的 pck sha256
>
> 维护人：@writer · 维护日期：2026-09-10 · 当前 HEAD：v0.2.1 (`126fe6e`)

---

## v0.2 锁版状态

> **v0.2 目标**：E03-v0.2 闭环验证（@ben-gao 拍板路径）：
> 新游戏 → 进洞拾剑 → 出洞（持剑）→ 击杀史莱姆 → 退出 → 重开（仍持剑）

| 项 | 当前值 |
|---|---|
| v0.2 pck sha256 | `d9239c713dfde5f8c78f83df05c71a9c3101111f7c432960602bd0ef0e10abe5` |
| v0.2 commit hash | `2f064cfa09cdc2b7a180ed6414f1e89fab8e5ea0`（短 `2f064cf`） |
| **v0.2.1 pck sha256** | `c53ae27346113c22bc172f041d4a66f21c954409e605c6d1fd2ff40bf2dac4fb`（仅清理） |
| **v0.2.1 commit hash** | `126fe6ecf220972d8af53c229ad41afcf8b9a194`（短 `126fe6e`） |
| exe sha256 | `4a9eaded...`（不变） |
| 下载 URL | `releases/tag/v0.0.1`（@general 重传 pck） |
| v0.2 包含修复 | 5 项拍板项 + 额外 slime shape 12×12 + enemy collision_layer=2 + 攻击白矩形 + enemy 死亡禁用 |
| v0.2.1 额外清理 | game.gd 删 ColorRect 死代码 + player.gd pickup_sword 加 [DEBUG] print + player.gd attack hit 加 [DEBUG] print + menu.gd 无 OS.window_size 调用（已核实） |

**v0.2 vs v0.2.1 说明**：
- **v0.2** 是主验证线（@ben-gao 6 步验收用）
- **v0.2.1** 仅清理 + debug，不影响主功能
- 如果 v0.2 验收成功，v0.2.1 可以不验收（主路径已通）

**v0.2 必须全绿的项**：
- [ ] 5 剑拾取（has_sword 同步）
- [ ] 6 剑攻击（空格挥剑）
- [ ] 7 敌人史莱姆（HP + 击杀）
- [ ] 8 存档系统（退出重开保留 has_sword）
- [ ] 11 PowerShell 无 queue_free 物理回调违规

**v0.2 已知遗留**（v0.2.1 已清理）：
- 🟢 game.gd::on_player_get_sword() 删除 ColorRect 死代码（v0.2.1 commit `126fe6e`）
- 🟢 pickup_sword() 加 [DEBUG] print 调试日志（v0.2.1）
- 🟢 attack hit 加 [DEBUG] print（v0.2.1）
- 🟢 menu.gd 已不用 OS.window_size（未发现）

**v0.2 vs v0.2.1 说明**：
- **v0.2** 是主验证线（@ben-gao 6 步验收用）—— commit `2f064cf`
- **v0.2.1** 仅清理 + debug，不影响主功能 —— commit `126fe6e`
- 如果 v0.2 验收成功，v0.2.1 可以不验收（主路径已通）

---

## 1. 玩家移动（WASD / 方向键四向）

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ✅
- **首次实现**：E01（commit `018664f`，v0.0.1）
- **最近修复**：commit `6128403`（统一移动参数到 80 px/s）
- **关联 pck**：v0.0.1（`4a9eaded...`）首测通过；v0.1.3（`0b98bdb3...`）验收通过
- **备注**：四向移动 + 碰墙碰撞

## 2. 玩家边界 clamp（6-234 / 6-154）

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ✅
- **首次实现**：E01（commit `018664f`）
- **最近修复**：commit `61edf24`（clamp y 上限 214，地板碰撞体修正）
- **关联 pck**：v0.0.3（`bfaad9e9...`）首测通过
- **备注**：240×160 viewport 内的边界 clamp；y 上限避免与地板重叠

## 3. 户外 overworld 场景

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ⏳ 待验证
- **首次实现**：E02（commit `34af161`）
- **关联 pck**：v0.0.3（`bfaad9e9...`）
- **备注**：main.tscn = 户外场景，含玩家 + 史莱姆 + 洞穴入口

## 4. 洞穴场景（进/出）

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ⏳ 待验证
- **首次实现**：E02（commit `34af161`）
- **最近修复**：v0.1.3 (commit `1e4aeb3` viewport 缩放后再次验证)
- **关联 pck**：v0.0.3（`bfaad9e9...`）
- **备注**：cave.tscn + Area2D CaveEntrance/CaveExit

## 5. 剑拾取（has_sword 同步）

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ⏳ 待验证
- **首次实现**：E02（commit `34af161`，v0.0.3）
- **最近修复**：commit `2f49383`（sword.tscn 加 8x8 shape + call_deferred queue_free + add_to_group）
- **关联 pck**：v0.1.1 / v0.1.3（`0b98bdb3...`）
- **状态同步链**：sword._on_body_entered → player.pickup_sword() → game.on_player_get_sword() → save_game()
- **本轮重点**：v0.2 闭环验收目标

## 6. 剑攻击（空格挥剑）

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ⏳ 待验证
- **首次实现**：E02（commit `34af161`）
- **关联 pck**：v0.0.5
- **备注**：has_sword 才可攻击；is_attacking 防抖
- **本轮重点**：v0.2 闭环验收目标

## 7. 敌人史莱姆（HP + 击杀）

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ⏳ 待验证
- **首次实现**：E02（commit `34af161`）
- **关联 pck**：v0.0.3
- **备注**：slime.tscn + enemy.gd，HP 字段、击退
- **本轮重点**：v0.2 闭环验收目标

## 8. 存档系统（退出重开保留 has_sword）

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ⏳ 待验证
- **首次实现**：E02（commit `34af161`，v0.0.5）
- **关联 pck**：v0.0.5
- **备注**：`user://save.dat` 路径；存 has_sword / room / player_xy
- **本轮重点**：v0.2 闭环验收目标（重开仍持剑）

## 9. 菜单系统（M 弹出 + 装备 + 退出）

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ⏳ 待验证
- **首次实现**：E02.5（commit `411619d`，v0.0.5）
- **最近修复**：commit `fa05bf8`（grab_focus + FOCUS_ALL + mouse_filter PASS）
- **关联 pck**：v0.1.2 / v0.1.3（`0b98bdb3...`）
- **备注**：HBoxContainer + grab_focus；v0.2 计划换像素字体

## 10. 缩放 F1/F2/F3

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ✅ · 🟢 **用户已验收** ⏳ 待验证
- **首次实现**：v0.0.9
- **最近修复**：commit `1e4aeb3`（aspect=keep + scale_mode=fractional）
- **关联 pck**：v0.1.3（`0b98bdb3...`）
- **备注**：F1=1x（240×160）/ F2=2x（480×320）/ F3=3x（720×480）

## 11. PowerShell 无报错（无 queue_free 物理回调违规）

- 🟡 **已写代码** ✅ · 🟠 **已运行验证** ⏳ 待复测 · 🟢 **用户已验收** ⏳ 待验证
- **首次实现**：commit `2f49383`（queue_free → call_deferred("queue_free")）
- **关联 pck**：v0.1.1 / v0.1.3（`0b98bdb3...`）
- **备注**：sword.gd 的 body_entered 已改 call_deferred，但 v0.1.1 仍报 3 次错误（推测 sword pickup 多次 trigger）

---

## 当前未实现 / 推迟项

| 项 | 推迟到 | 原因 |
|---|---|---|
| 剑 collision shape 8×8 → 12×12 | v0.2+ | @ben-gao 21:38 拍板：「不扩大范围，优先核心闭环」 |
| 菜单像素字体 | v0.2+ | 同上 |
| Wall/Floor/Cave ColorRect → Polygon2D | v0.3+ | 历史遗留能渲染，R02 §6.4.3 约束 #2 不合规但不阻塞 |
| 场景背景音乐 / 音效 | E03+ | 用户拍板：先做样板，不做音效 |

## 验收路径（v0.2 目标）

```
新游戏 → 进洞 → 拾剑 → 出洞（持剑）→ 击杀史莱姆 → 退出 → 重开（仍持剑）
```

每一步对应上述状态表中的一项「🟢 用户已验收」。

---

## 关联

- README.md（项目入口）
- CONTRIBUTING.md（协作约定）
- DECISIONS.md（决策日志）
- TASK_TEMPLATE.md（任务模板）
- v0.1.0_BLOCKER_ANALYSIS.md（卡点分析模板）
- research/R01 / R02 / R03（调研报告）