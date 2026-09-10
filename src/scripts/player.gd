extends CharacterBody2D

## 林克：四向移动 + 朝向 + 剑攻击
## 键位：WASD/方向键移动，空格攻击

const SPEED: float = 80.0
const ATTACK_DURATION: float = 0.2
const ATTACK_RANGE: float = 14.0

var facing: Vector2 = Vector2.DOWN
var has_sword: bool = false
var is_attacking: bool = false

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# 攻击中不动
	if is_attacking:
		position.x = clamp(position.x, 6.0, 234.0)
		position.y = clamp(position.y, 6.0, 154.0)
		return
	
	var direction := Vector2.ZERO
	
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1
		facing = Vector2.UP
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1
		facing = Vector2.DOWN
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
		facing = Vector2.LEFT
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1
		facing = Vector2.RIGHT
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	velocity = direction * SPEED
	move_and_slide()
	
	# 边界（统一 240×160）
	position.x = clamp(position.x, 6.0, 234.0)
	position.y = clamp(position.y, 6.0, 154.0)
	
	if Input.is_key_pressed(KEY_SPACE) and has_sword and not is_attacking:
		perform_attack()

func _draw() -> void:
	var color = Color(0.4, 0.7, 1.0, 1.0) if has_sword else Color(1.0, 0.5, 0.0, 1.0)
	draw_rect(Rect2(-4, -4, 8, 8), color)
	if is_attacking:
		# 攻击时画一个朝向方向的矩形（视觉提示）
		var attack_color = Color(1, 1, 1, 0.7)
		var ar = Rect2()
		match facing:
			Vector2.UP: ar = Rect2(-3, -4 - 8, 6, 8)
			Vector2.DOWN: ar = Rect2(-3, 4, 6, 8)
			Vector2.LEFT: ar = Rect2(-4 - 8, -3, 8, 6)
			Vector2.RIGHT: ar = Rect2(4, -3, 8, 6)
		draw_rect(ar, attack_color)

func perform_attack() -> void:
	is_attacking = true
	queue_redraw()
	# 攻击时检测朝向方向敌人
	check_attack_hit()
	await get_tree().create_timer(ATTACK_DURATION).timeout
	is_attacking = false
	queue_redraw()

func check_attack_hit() -> void:
	# 用 space_state 直接查询矩形区域
	var space = get_world_2d().direct_space_state
	var attack_offset = facing * ATTACK_RANGE / 2
	var query_center = position + attack_offset
	var query_size = Vector2()
	match facing:
		Vector2.UP, Vector2.DOWN:
			query_size = Vector2(12, ATTACK_RANGE)
		Vector2.LEFT, Vector2.RIGHT:
			query_size = Vector2(ATTACK_RANGE, 12)
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.collision_mask = 2  # enemy layer
	query.collision_shape = RectangleShape2D.new()
	(query.collision_shape as RectangleShape2D).size = query_size
	query.transform = Transform2D(0, query_center)
	
	var results = space.intersect_shape(query, 4)
	print("[DEBUG] attack facing=", facing, " results=", results.size())
	for r in results:
		var collider = r.get("collider")
		if collider and collider.has_method("take_damage"):
			print("[DEBUG] hit enemy: ", collider.name)
			collider.take_damage()

func pickup_sword() -> void:
	print("[DEBUG] pickup_sword called, has_sword before=", has_sword)
	if has_sword:
		return
	has_sword = true
	queue_redraw()
	# 同步到 game manager
	var game_nodes = get_tree().get_nodes_in_group("game")
	if game_nodes.size() > 0:
		game_nodes[0].on_player_get_sword()
		print("[DEBUG] game.has_sword synced, game.has_sword=", game_nodes[0].has_sword)
