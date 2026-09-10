extends Area2D

## 剑道具：林克接触后拾取
## 注意：queue_free 必须在物理回调外调用（用 call_deferred）

signal sword_picked_up

func _ready() -> void:
	monitoring = true
	monitorable = true
	collision_layer = 4
	collision_mask = 1
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		body.pickup_sword()
		# 延迟删除避免物理回调中删除节点错误
		call_deferred("queue_free")
