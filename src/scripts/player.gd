extends CharacterBody2D

## 林克角色：四向移动 + 碰撞检测
## 键位：WASD / 方向键

const SPEED: float = 80.0  # 像素/秒

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	velocity = direction * SPEED
	move_and_slide()
	
	# 限制在视口内（防止出界）
	var vp_rect = get_viewport_rect()
	position.x = clamp(position.x, 8, vp_rect.size.x - 8)
	position.y = clamp(position.y, 8, vp_rect.size.y - 8)
