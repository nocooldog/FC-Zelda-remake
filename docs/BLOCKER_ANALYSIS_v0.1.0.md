# E02.5 卡点详细分析（v0.1.0）

> 目标：让外部 AI（ChatGPT / Gemini / Claude）能基于此文档分析卡点原因并给出修复建议。
> 提交日期：2026-09-10
> 当前 pck SHA256: 160e7fe50efe5ec507a75d4ecb31ede53ffeeb145ee2950566592752ddc584c8
> 项目版本：v0.1.0

## 一、项目背景

- **引擎**：Godot 4.7.2 stable + GDScript
- **分辨率**：GBA 240×160（viewport），stretch mode="viewport" + aspect="keep"
- **平台**：Windows 11（Surface Pro 8），从 GitHub Release 下载 exe + pck
- **仓库**：`/home/ben/zelda-remake/`
- **GitHub**：https://github.com/nocooldog/FC-Zelda-remake
- **当前 release**：https://github.com/nocooldog/FC-Zelda-remake/releases/tag/v0.0.1

## 二、当前已实现功能

### 场景
- **main.tscn**（户外）：橙色林克 + 绿色史莱姆（左右巡逻）+ 黑色洞穴入口（顶部）
- **cave.tscn**（洞穴）：林克 + 灰色剑（位于 x=120, y=150）+ 棕色老人

### 交互
- WASD/方向键：四向移动
- 空格键：有剑时挥剑攻击
- M 键：打开/关闭暂停菜单

### 存档
- 路径 `user://save.dat`，首次拾剑时自动保存
- 下次启动时若已有剑，菜单显示 "剑:有"

## 三、卡点问题（按严重度排）

### 🔴 卡点 1：洞穴内无法拾取剑

**现象**：
- 进入洞穴后，灰色剑显示在 (120, 150) 位置
- 林克走到剑上（视觉上重叠），剑不消失
- 林克颜色不变蓝（应变蓝表示有剑）
- 菜单显示 SWORD:NO

**代码现状**：

`src/scenes/sword.tscn`：
```
[gd_scene load_steps=2 format=3 uid="uid://sword01"]

[ext_resource type="Script" path="res://scripts/sword.gd" id="1"]

[node name="Sword" type="Area2D"]
script = ExtResource("1")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
```

**问题**：Sword 节点的 CollisionShape2D 没有 shape 资源引用！意味着没有实际碰撞形状。

`src/scripts/sword.gd`：
```
extends Area2D
signal sword_picked_up

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.pickup_sword()
		queue_free()
```

`src/scenes/cave.tscn` 剑的位置：
```
[node name="SwordSpawn" type="Node2D" parent="."]
position = Vector2(120, 150)

[node name="Sword" parent="SwordSpawn" instance=ExtResource("2_sword")]
```

**疑问**：
- CollisionShape2D 没有引用 shape，可能是问题根源
- 或者 player 是 CharacterBody2D，需要 Area2D 用 body_entered 才能检测（已改）

### 🔴 卡点 2：菜单退出按钮无法选中

**现象**：
- M 键打开菜单，能看到"装备"/"退出"两项 + ^ 游标
- 按左右键：^ 游标不移动
- 按空格：菜单没有反应（既不弹确认，也不退出）

**代码现状**：

`src/scripts/menu.gd` 关键部分：
```gdscript
func _input(event: InputEvent) -> void:
	if not visible:
		if event is InputEventKey and event.pressed and event.keycode == KEY_M:
			_open()
		return
	if not (event is InputEventKey and event.pressed):
		return
	match state:
		State.MENU:
			if event.keycode in [KEY_LEFT, KEY_A]:
				selected = 0
				_update()
			elif event.keycode in [KEY_RIGHT, KEY_D]:
				selected = 1
				_update()
			elif event.keycode in [KEY_M, KEY_ESCAPE]:
				_close()
			elif event.keycode in [KEY_SPACE, KEY_ENTER]:
				if selected == 1:
					_show_confirm()
		State.CONFIRM:
			...
```

菜单打开流程：
```gdscript
func _open() -> void:
	_update_sword()
	selected = 1    # 默认选退出
	confirm_sel = 1
	state = State.MENU
	confirm_panel.visible = false
	visible = true
	get_tree().paused = true
	_update()
```

菜单是 CanvasLayer 子节点（autoload）。

**疑问**：
- CanvasLayer 是否能正常接收 `_input`？
- CanvasLayer + PanelContainer 是否会拦截事件？
- 当 `get_tree().paused = true` 时，`_input` 是否仍能接收？

### 🟡 卡点 3：缩放不同步

**现象**：
- F1（1x）：完整显示 240×160 居中
- F2（2x）：窗口 480×320，但内容偏右，左侧裁剪
- F3（3x）：窗口 720×480，菜单 left 边被裁掉

**代码现状**：

`src/project.godot`：
```
[display]
window/size/viewport_width=240
window/size/viewport_height=160
window/size/resizable=false
window/stretch/mode="viewport"
window/stretch/aspect="keep"
```

`src/scripts/game.gd` 的 _change_scale：
```gdscript
func _change_scale(s: int) -> void:
	_scale = s
	resize_window()

func resize_window() -> void:
	get_window().size = Vector2i(BASE_W * _scale, BASE_H * _scale)
	get_window().center()
```

**疑问**：
- stretch_mode=viewport 应该让 viewport 内的 240×160 缩放到 window size
- 但实际表现是窗口变了但 viewport 没缩放
- 是否需要改用 `content_scale_factor`？

## 四、已知坑（已踩过）

1. **ColorRect 在 CharacterBody2D 下渲染不稳定**：改用 `_draw()` 函数
2. **Polygon2D 的 polygon 数组序列化有 bug**：不用
3. **Godot pck 缓存**：每次必须 `rm -rf .godot/` 再打包
4. **exe SHA256 永远是 `4a9eaded...`**：游戏内容在 .pck
5. **ColorRect 在 StaticBody2D 下物理/渲染可能错位**：已用

## 五、问题总结（请外部 AI 重点关注）

### 优先级 1：剑拾取
- sword.tscn 的 CollisionShape2D 缺 shape 引用
- sword.gd 改用 body_entered（player 是 CharacterBody2D）
- 需要：CollisionShape2D + RectangleShape2D resource，大小匹配剑视觉（8x8）

### 优先级 2：菜单退出
- CanvasLayer + autoload 模式下 `_input` 是否被 PanelContainer 拦截？
- 试用过 `_unhandled_input`（也不行）
- `get_tree().paused = true` 时事件流是否改变？

### 优先级 3：缩放
- `get_window().size = ...` + stretch_mode=viewport 不能正确缩放
- 是否需要改用 `Window.content_scale_factor`？

## 六、相关文件路径

- `/home/ben/zelda-remake/src/scenes/sword.tscn`
- `/home/ben/zelda-remake/src/scripts/sword.gd`
- `/home/ben/zelda-remake/src/scripts/menu.gd`
- `/home/ben/zelda-remake/src/scenes/player.tscn`
- `/home/ben/zelda-remake/src/scripts/player.gd`
- `/home/ben/zelda-remake/src/scenes/cave.tscn`
- `/home/ben/zelda-remake/src/project.godot`
- `/home/ben/zelda-remake/src/scripts/game.gd`

## 七、运行环境

- Godot 4.7.2 stable
- Linux 服务器：macmini02 (Ubuntu 22.04)
- 测试设备：Surface Pro 8 + Windows 11
- v2ray 代理在 localhost:1080
- GitHub token: (使用环境变量或本地配置；不要硬编码到 git 仓里)

## 八、复现步骤

1. 双击 `zelda-prototype.exe`（pck 已下到同目录）
2. 林克出现，方向键移到顶部黑色洞穴入口
3. 自动进入 cave.tscn
4. 看到灰色剑在中央偏下，移动林克到剑上
5. 剑不消失，林克不变蓝
6. 按 M 键打开菜单
7. 按左右键切换焦点 ^ 不动
8. 按空格，没反应

