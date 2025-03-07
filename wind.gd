class_name Wind
extends Node

@export var max_speed: float
@export var min_speed: float

signal randomize_wind
signal set_wind(speed:float, direction:Vector2)

var _rng = RandomNumberGenerator.new()
var _speed: float
var _direction: Vector2

func _ready() -> void:
	_on_wind_set_wind(50, Vector2(1,1))

func _on_wind_randomize_wind() -> void:
	_speed = _rng.randf_range(min_speed, max_speed)
	_direction = Vector2(1,0).rotated(_rng.randf_range(0, PI*2))

func _on_wind_set_wind(speed: float, direction: Vector2) -> void:
	_speed = speed
	_direction = direction.normalized()

func _physics_process(delta: float) -> void:
	var affected_objects = get_tree().get_nodes_in_group("wind_affected")
	for affected_object in affected_objects:
		if affected_object is RigidBody2D:
			if affected_object.linear_velocity.length() < _speed:
				affected_object.apply_central_force(_direction * _speed)
			print_debug(affected_object.linear_velocity)
			
			pass
		
		if affected_object is CharacterBody2D:
			var save_velocity = affected_object.velocity
			affected_object.velocity = _direction * _speed * delta * 60
			affected_object.move_and_slide()
			affected_object.velocity = save_velocity
			pass
	
