extends AnimatedSprite2D

func _ready() -> void:
	play("impact2")

func _on_animation_finished() -> void:
	queue_free()
