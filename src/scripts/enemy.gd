extends CharacterBody2D

## 史莱姆敌人：简单巡逻 + 可被剑击杀

const SPEED: float = 30.0
var direction: Vector2 = Vector2.RIGHT
var health: int = 1
var is_dead: bool = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	velocity = direction * SPEED
	move_and_slide()
	
	position.x = clamp(position.x, 6.0, 234.0)
	position.y = clamp(position.y, 6.0, 154.0)
	
	# 碰墙反向
	if position.x <= 6.0 or position.x >= 250.0:
		direction.x *= -1
	if position.y <= 6.0 or position.y >= 218.0:
		direction.y *= -1

func take_damage() -> void:
	health -= 1
	if health <= 0:
		die()

func die() -> void:
	is_dead = true
	# 变色表示死亡
	modulate = Color(0.5, 0.5, 0.5, 0.5)
	await get_tree().create_timer(0.5).timeout
	queue_free()
