class_name WindParticle
extends Sprite2D

@export var opacity_decay = 0.995

var _speed = 0
var _direction = Vector2(0, 0)

func is_visible_on_screen() -> bool:
	return modulate.a > 0.01 and $VisibleOnScreenNotifier2D.is_on_screen()


func reset(position: Vector2, speed: float, direction: Vector2) -> void:
	_speed = speed
	_direction = direction
	self.position = position
	rotation = atan2(_direction.y, _direction.x)
	modulate = Color(1, 1, 1, randf_range(0.2, 0.4))
	visible = true

func _process(delta: float) -> void:
	position += _speed * delta * _direction
	modulate.a *= opacity_decay
