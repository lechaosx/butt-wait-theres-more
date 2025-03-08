extends AnimatedSprite2D

func _ready() -> void:
	play("impact")

func _on_animation_finished() -> void:
	queue_free()
