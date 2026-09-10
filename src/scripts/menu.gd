extends CanvasLayer

## 暂停菜单（M 键打开）

enum State { MENU, CONFIRM }
enum MenuOption { QUIT }
enum ConfirmOption { YES, NO }

var state: State = State.MENU
var selected: MenuOption = MenuOption.QUIT
var confirm_selected: ConfirmOption = ConfirmOption.NO

# UI 节点
var panel: PanelContainer
var menu_label: Label
var equip_label: Label
var sword_label: Label
var quit_label: Label
var confirm_panel: PanelContainer
var yes_label: Label
var no_label: Label
var prompt_label: Label

func _ready() -> void:
	visible = false
	_create_ui()

func _create_ui() -> void:
	# 背景遮罩
	var bg = ColorRect.new()
	bg.color = Color(0, 0, 0, 0.6)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	# 主面板
	panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -60
	panel.offset_top = -50
	panel.offset_right = 60
	panel.offset_bottom = 50
	panel.color = Color(0.1, 0.1, 0.2, 0.95)
	add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.custom_minimum_size = Vector2(120, 0)
	panel.add_child(vbox)
	
	# 标题
	var title = Label.new()
	title.text = "≡ 菜单 ≡"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 14)
	vbox.add_child(title)
	
	_add_spacer(vbox, 6)
	
	# 装备
	equip_label = Label.new()
	equip_label.text = "装备："
	equip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	equip_label.add_theme_font_size_override("font_size", 10)
	vbox.add_child(equip_label)
	
	sword_label = Label.new()
	sword_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sword_label.add_theme_font_size_override("font_size", 10)
	_update_sword_label()
	vbox.add_child(sword_label)
	
	_add_spacer(vbox, 8)
	
	# 提示
	prompt_label = Label.new()
	prompt_label.text = "← → 选择"
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.add_theme_font_size_override("font_size", 9)
	vbox.add_child(prompt_label)
	
	# 退出按钮
	quit_label = Label.new()
	quit_label.name = "Quit"
	quit_label.text = "[ 退出 ]"
	quit_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	quit_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(quit_label)
	
	_add_spacer(vbox, 4)
	
	# 确认面板（隐藏）
	confirm_panel = PanelContainer.new()
	confirm_panel.set_anchors_preset(Control.PRESET_CENTER)
	confirm_panel.offset_left = -55
	confirm_panel.offset_top = -35
	confirm_panel.offset_right = 55
	confirm_panel.offset_bottom = 35
	confirm_panel.color = Color(0.05, 0.05, 0.15, 0.98)
	confirm_panel.visible = false
	add_child(confirm_panel)
	
	var cvbox = VBoxContainer.new()
	cvbox.alignment = BoxContainer.ALIGNMENT_CENTER
	confirm_panel.add_child(cvbox)
	
	var q = Label.new()
	q.text = "确认退出？"
	q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	q.add_theme_font_size_override("font_size", 11)
	cvbox.add_child(q)
	
	_add_spacer(cvbox, 4)
	
	var optrow = HBoxContainer.new()
	optrow.alignment = HBoxContainer.ALIGNMENT_CENTER
	cvbox.add_child(optrow)
	
	yes_label = Label.new()
	yes_label.text = "[ 是 ]"
	yes_label.add_theme_font_size_override("font_size", 11)
	optrow.add_child(yes_label)
	
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(16, 0)
	optrow.add_child(spacer2)
	
	no_label = Label.new()
	no_label.text = "[ 再想想 ]"
	no_label.add_theme_font_size_override("font_size", 11)
	optrow.add_child(no_label)
	
	_update_menu_highlight()

func _add_spacer(parent: Control, height: float) -> void:
	var s = Control.new()
	s.custom_minimum_size = Vector2(0, height)
	parent.add_child(s)

func _update_sword_label() -> void:
	var has_sword = false
	if get_tree().get_nodes_in_group("game").size() > 0:
		var game = get_tree().get_nodes_in_group("game")[0]
		has_sword = game.has_sword
	sword_label.text = "  " + ("⚔ 有剑" if has_sword else "无剑")

func _update_menu_highlight() -> void:
	quit_label.add_theme_color_override("font_color", Color(1, 1, 1) if selected == MenuOption.QUIT else Color(0.6, 0.6, 0.6))
	yes_label.add_theme_color_override("font_color", Color(1, 1, 0.5) if confirm_selected == ConfirmOption.YES else Color(0.6, 0.6, 0.6))
	no_label.add_theme_color_override("font_color", Color(1, 1, 0.5) if confirm_selected == ConfirmOption.NO else Color(0.6, 0.6, 0.6))

func _input(event: InputEvent) -> void:
	if not visible:
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_M:
				_open_menu()
		return
	
	if event is InputEventKey and event.pressed:
		match state:
			State.MENU:
				if event.keycode == KEY_M or event.keycode == KEY_ESCAPE:
					_close_menu()
				elif event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
					if selected == MenuOption.QUIT:
						_show_confirm()
			State.CONFIRM:
				if event.keycode == KEY_LEFT or event.keycode == KEY_RIGHT:
					confirm_selected = ConfirmOption.YES if confirm_selected == ConfirmOption.NO else ConfirmOption.NO
					_update_menu_highlight()
				elif event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
					if confirm_selected == ConfirmOption.YES:
						get_tree().quit()
					else:
						_hide_confirm()

func _open_menu() -> void:
	visible = true
	state = State.MENU
	_update_sword_label()
	_update_menu_highlight()
	get_tree().paused = true

func _close_menu() -> void:
	visible = false
	get_tree().paused = false

func _show_confirm() -> void:
	state = State.CONFIRM
	confirm_selected = ConfirmOption.NO
	confirm_panel.visible = true
	_update_menu_highlight()

func _hide_confirm() -> void:
	state = State.MENU
	confirm_panel.visible = false
	_update_menu_highlight()
