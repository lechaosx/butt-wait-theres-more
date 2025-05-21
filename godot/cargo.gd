extends Area2D

@export var float_speed: float = 0.3

var _rotation_target: float = (-1 if randf() > 0.5 else 1) * randf_range(0, PI / 6)

func _on_body_entered(body: Node2D) -> void:
	if "cargo" in body:
		body.cargo += 1
		$AudioStreamPlayer2D.play()
		$Sprite2D.visible = false
		queue_free()

func _process(delta: float) -> void:
	rotation = rotate_toward(rotation, _rotation_target, float_speed * delta * cos(_rotation_target - rotation))
	if abs(_rotation_target - rotation) < 0.01:
		_rotation_target = randf_range(0, PI / 6) * -1 * sign(_rotation_target)
