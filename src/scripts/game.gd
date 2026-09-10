extends Node2D

## 游戏管理器：场景切换 + 存档

const SAVE_PATH = "user://save.dat"

var current_room: String = "main"
var has_sword: bool = false

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	add_to_group("game")
	load_game()
	set_sword_visibility()
	connect_transition_zones()

func connect_transition_zones() -> void:
	# 连接洞穴入口（从主场景进洞）
	var entrance = get_node_or_null("CaveEntrance")
	if entrance:
		entrance.body_entered.connect(_on_cave_entrance)
	# 连接洞穴出口（从洞穴出来）
	var exit_area = get_node_or_null("CaveExit")
	if exit_area:
		exit_area.body_entered.connect(_on_cave_exit)

func _on_cave_entrance(body: Node2D) -> void:
	if body == player:
		current_room = "cave"
		transition_to_cave()

func _on_cave_exit(body: Node2D) -> void:
	if body == player:
		current_room = "main"
		transition_to_overworld()

func on_player_get_sword() -> void:
	has_sword = true
	save_game()
	if player:
		var cr = player.get_node_or_null("ColorRect")
		if cr:
			cr.color = Color(0.5, 0.8, 1.0, 1.0)  # 蓝色表示有剑

func transition_to_overworld() -> void:
	save_game()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func transition_to_cave() -> void:
	save_game()
	get_tree().change_scene_to_file("res://scenes/cave.tscn")

func save_game() -> void:
	var save_data = {
		"has_sword": has_sword,
		"room": current_room,
		"player_x": player.position.x if player else 128.0,
		"player_y": player.position.y if player else 150.0
	}
	var f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_var(save_data)
		f.close()

func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var f = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if f:
			var d: Dictionary = f.get_var()
			f.close()
			has_sword = d.get("has_sword", false)

func set_sword_visibility() -> void:
	var sword = $SwordSpawn.get_node_or_null("Sword")
	if sword:
		sword.visible = not has_sword
