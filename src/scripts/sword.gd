extends Area2D

## 剑道具：林克接触后拾取

signal sword_picked_up

func _ready() -> void:
	# 同时监听 area 和 body 进入（player 是 CharacterBody2D）
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.pickup_sword()
		queue_free()
