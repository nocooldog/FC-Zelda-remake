extends CharacterBody2D

## 林克：四向移动 + 朝向 + 剑攻击
## 键位：WASD/方向键移动，空格攻击

const SPEED: float = 80.0
var facing: Vector2 = Vector2.DOWN
var has_sword: bool = false
var is_attacking: bool = false
const ATTACK_DURATION: float = 0.2

func _physics_process(delta: float) -> void:
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
	
	position.x = clamp(position.x, 6.0, 234.0)
	position.y = clamp(position.y, 6.0, 154.0)
	
	if Input.is_key_pressed(KEY_SPACE) and has_sword and not is_attacking:
		perform_attack()

func _draw() -> void:
	var color = Color(0.4, 0.7, 1.0, 1.0) if has_sword else Color(1.0, 0.5, 0.0, 1.0)
	draw_rect(Rect2(-4, -4, 8, 8), color)

func perform_attack() -> void:
	is_attacking = true
	await get_tree().create_timer(ATTACK_DURATION).timeout
	is_attacking = false

func pickup_sword() -> void:
	has_sword = true
	queue_redraw()
	# 通知 game manager
	if get_tree().get_nodes_in_group("game").size() > 0:
		get_tree().get_nodes_in_group("game")[0].on_player_get_sword()
