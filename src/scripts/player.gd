extends CharacterBody2D

const SPEED: float = 80.0

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
	
	position.x = clamp(position.x, 6.0, 250.0)
	position.y = clamp(position.y, 6.0, 218.0)
