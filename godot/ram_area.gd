class_name RamArea extends Area2D

signal rammed(body: Node2D)

@export var damage: int = 1

func _on_body_entered(body: Node2D) -> void:
	if "health" in body:
		body.health -= damage
		rammed.emit(body)
