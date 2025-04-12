extends Area2D

@export var float_speed: float = 0.3

var _rotation_target: float

func _init() -> void:
	_rotation_target = (-1 if randf() > 0.5 else 1) * randf_range(0, PI / 6)

func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is CargoHold:
			child.add_cargo(1)
			$AudioStreamPlayer2D.play()
			$Sprite2D.visible = false
			$CollisionShape2D.set_deferred("disabled", false)
			$Timer.start()

func _process(delta: float) -> void:
	rotation = rotate_toward(rotation, _rotation_target, float_speed * delta * cos(_rotation_target - rotation))
	if abs(_rotation_target - rotation) < 0.01:
		_rotation_target = randf_range(0, PI / 6) * -1 * sign(_rotation_target)


func _on_timer_timeout() -> void:
	queue_free()
