extends Area2D

func _ready() -> void:
	await $AnimatedSprite2D.animation_finished
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "health" in body:
		body.health -= 10 # Could be based off square distance or something
