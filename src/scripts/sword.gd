extends Area2D

## 剑道具：林克接触后拾取

signal sword_picked_up

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		area.pickup_sword()
		queue_free()
