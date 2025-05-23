class_name DamageArea extends Area2D

signal damaged(body: Node2D)

@export var parent: PhysicsBody2D

@export var damage: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body == parent:
		return
		
	if "health" in body:
		body.health -= damage
		damaged.emit(body)
