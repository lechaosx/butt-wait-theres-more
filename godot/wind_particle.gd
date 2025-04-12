class_name WindParticle
extends Sprite2D

@export var opacity_decay: float = 0.998

var _speed: float = 0
var _direction := Vector2(0, 0)

var _speed_random_coef: float

func is_visible_on_screen() -> bool:
	return modulate.a > 0.01 and $VisibleOnScreenNotifier2D.is_on_screen()


func reset(new_position: Vector2, speed: float, direction: Vector2) -> void:
	_speed_random_coef = randf_range(0.8, 1.2)
	_speed = speed * _speed_random_coef
	_direction = direction
	self.position = new_position
	rotation = _direction.angle()
	modulate = Color(1, 1, 1, randf_range(0.2, 0.4))
	visible = true
	
	
func change_direction(speed: float, direction: Vector2) -> void:
	_speed = speed * _speed_random_coef
	_direction = direction
	rotation = _direction.angle()
	

func _process(delta: float) -> void:
	position += _speed * delta * _direction
	modulate.a *= opacity_decay
