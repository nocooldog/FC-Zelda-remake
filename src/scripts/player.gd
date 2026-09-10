extends CharacterBody2D

## 林克：四向移动 + 朝向 + 剑攻击
## 键位：WASD/方向键移动，空格攻击

const SPEED: float = 80.0

# 方向状态
var facing: Vector2 = Vector2.DOWN  # 当前朝向

# 剑状态
var has_sword: bool = false
var is_attacking: bool = false
const ATTACK_DURATION: float = 0.2  # 秒
const ATTACK_RANGE: float = 14.0   # 攻击范围

# 攻击碰撞区域（朝向方向的额外碰撞检测）
var attack_hitbox: Rect2 = Rect2(0, 0, 8, 8)

func _physics_process(delta: float) -> void:
	if is_attacking:
		# 攻击中不移动
		position.x = clamp(position.x, 6.0, 250.0)
		position.y = clamp(position.y, 6.0, 218.0)
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
	
	# 按空格攻击
	if Input.is_key_pressed(KEY_SPACE) and has_sword and not is_attacking:
		perform_attack()

func perform_attack() -> void:
	is_attacking = true
	await get_tree().create_timer(ATTACK_DURATION).timeout
	is_attacking = false

func pickup_sword() -> void:
	has_sword = true
	# 通知场景有新剑（触发 UI 更新等）
	get_tree().call_group("game", "on_player_get_sword")
