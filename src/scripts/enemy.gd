extends CharacterBody2D

## 史莱姆敌人：简单巡逻 + 可被剑击杀

const SPEED: float = 30.0
var direction: Vector2 = Vector2.RIGHT
var health: int = 1
var is_dead: bool = false

func _ready() -> void:
	add_to_group("enemy")
	collision_layer = 2  # enemy layer
	collision_mask = 1  # collide with world (player layer)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	velocity = direction * SPEED
	move_and_slide()
	
	# 统一 240×160 边界
	position.x = clamp(position.x, 6.0, 234.0)
	position.y = clamp(position.y, 6.0, 154.0)
	
	# 碰墙反向
	if position.x <= 6.0 or position.x >= 234.0:
		direction.x *= -1
	if position.y <= 6.0 or position.y >= 154.0:
		direction.y *= -1

func take_damage() -> void:
	if is_dead:
		return
	health -= 1
	if health <= 0:
		die()

func die() -> void:
	is_dead = true
	collision_layer = 0
	collision_mask = 0
	velocity = Vector2.ZERO
	# 变色表示死亡
	modulate = Color(0.5, 0.5, 0.5, 0.5)
	set_process(false)
	set_physics_process(false)
	await get_tree().create_timer(0.5).timeout
	call_deferred("queue_free")
