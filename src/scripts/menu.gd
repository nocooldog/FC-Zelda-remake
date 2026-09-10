extends CanvasLayer

## 暂停菜单（M 键打开）
## 左右键切换"装备"和"退出"，空格确认

enum State { NONE, MENU, CONFIRM }

var state: State = State.NONE
var selected: int = 1   # 0=装备, 1=退出
var confirm_sel: int = 1 # 0=是的, 1=再想想

var sword_val_label: Label
var arrow1: Label
var arrow2: Label
var panel: PanelContainer
var confirm_panel: PanelContainer
var yes_lbl: Label
var no_lbl: Label

func _ready() -> void:
	visible = false
	_build_ui()

func _build_ui() -> void:
	panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.focus_mode = Control.FOCUS_ALL
	panel.offset_left = -72
	panel.offset_top = -32
	panel.offset_right = 72
	panel.offset_bottom = 32
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0.06, 0.04, 0.01, 0.95)
	panel.add_theme_stylebox_override("panel", sb)
	add_child(panel)
	
	var hbox = HBoxContainer.new()
	hbox.alignment = HBoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 28)
	panel.add_child(hbox)
	
	# === 装备项 ===
	var equip_box = VBoxContainer.new()
	equip_box.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_child(equip_box)
	
	arrow1 = Label.new()
	arrow1.text = "^"
	arrow1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	arrow1.add_theme_font_size_override("font_size", 9)
	arrow1.add_theme_color_override("font_color", Color(1, 1, 0.3))
	arrow1.visible = false
	equip_box.add_child(arrow1)
	
	var e1 = Label.new()
	e1.text = "装备"
	e1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	e1.add_theme_font_size_override("font_size", 11)
	equip_box.add_child(e1)
	
	sword_val_label = Label.new()
	sword_val_label.text = "无剑"
	sword_val_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sword_val_label.add_theme_font_size_override("font_size", 9)
	sword_val_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	equip_box.add_child(sword_val_label)
	
	# === 退出项 ===
	var quit_box = VBoxContainer.new()
	quit_box.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_child(quit_box)
	
	arrow2 = Label.new()
	arrow2.text = "^"
	arrow2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	arrow2.add_theme_font_size_override("font_size", 9)
	arrow2.add_theme_color_override("font_color", Color(1, 1, 0.3))
	arrow2.visible = false
	quit_box.add_child(arrow2)
	
	var q1 = Label.new()
	q1.text = "退出"
	q1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	q1.add_theme_font_size_override("font_size", 11)
	quit_box.add_child(q1)
	
	var q2 = Label.new()
	q2.text = "→ ← 选"
	q2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	q2.add_theme_font_size_override("font_size", 7)
	q2.add_theme_color_override("font_color", Color(0.45, 0.45, 0.45))
	quit_box.add_child(q2)
	
	# === 确认面板 ===
	confirm_panel = PanelContainer.new()
	confirm_panel.set_anchors_preset(Control.PRESET_CENTER)
	confirm_panel.offset_left = -68
	confirm_panel.offset_top = -30
	confirm_panel.offset_right = 68
	confirm_panel.offset_bottom = 30
	var sb2 = StyleBoxFlat.new()
	sb2.bg_color = Color(0.04, 0.02, 0.01, 0.98)
	confirm_panel.add_theme_stylebox_override("panel", sb2)
	confirm_panel.visible = false
	add_child(confirm_panel)
	
	var cvb = VBoxContainer.new()
	cvb.alignment = BoxContainer.ALIGNMENT_CENTER
	cvb.add_theme_constant_override("separation", 5)
	confirm_panel.add_child(cvb)
	
	var lq = Label.new()
	lq.text = "确认退出？"
	lq.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lq.add_theme_font_size_override("font_size", 10)
	cvb.add_child(lq)
	
	var row = HBoxContainer.new()
	row.alignment = HBoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 18)
	cvb.add_child(row)
	
	yes_lbl = Label.new()
	yes_lbl.text = "是的"
	yes_lbl.add_theme_font_size_override("font_size", 10)
	row.add_child(yes_lbl)
	
	no_lbl = Label.new()
	no_lbl.text = "再想想"
	no_lbl.add_theme_font_size_override("font_size", 10)
	row.add_child(no_lbl)
	
	_update()

func _update() -> void:
	arrow1.visible = (selected == 0)
	arrow2.visible = (selected == 1)
	
	yes_lbl.add_theme_color_override("font_color", Color(1,1,0.3) if confirm_sel==0 else Color(0.65,0.65,0.65))
	no_lbl.add_theme_color_override("font_color", Color(1,1,0.3) if confirm_sel==1 else Color(0.65,0.65,0.65))
	
	_update_sword()

func _update_sword() -> void:
	var s = false
	if get_tree().get_nodes_in_group("game").size() > 0:
		s = get_tree().get_nodes_in_group("game")[0].has_sword
	sword_val_label.text = "剑:" + ("有" if s else "无")

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
				# 任意项上按空格：装备项暂不动作，退出项打开确认
				if selected == 1:
					_show_confirm()
		State.CONFIRM:
			if event.keycode in [KEY_LEFT, KEY_A]:
				confirm_sel = 0
				_update()
			elif event.keycode in [KEY_RIGHT, KEY_D]:
				confirm_sel = 1
				_update()
			elif event.keycode == KEY_ESCAPE:
				_hide_confirm()
			elif event.keycode in [KEY_SPACE, KEY_ENTER]:
				if confirm_sel == 0:
					get_tree().quit()
				else:
					_hide_confirm()

func _open() -> void:
	_update_sword()
	selected = 1
	confirm_sel = 1
	state = State.MENU
	confirm_panel.visible = false
	visible = true
	get_tree().paused = true
	_update()
	# grab focus 到主面板
	panel.grab_focus()

func _close() -> void:
	visible = false
	get_tree().paused = false
	state = State.NONE

func _show_confirm() -> void:
	state = State.CONFIRM
	confirm_sel = 1
	confirm_panel.visible = true
	_update()

func _hide_confirm() -> void:
	state = State.MENU
	confirm_panel.visible = false
	_update()
