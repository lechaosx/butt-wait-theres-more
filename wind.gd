class_name Wind
extends Node

@export var max_speed: float
@export var min_speed: float
@export var max_change_duration: float
@export var min_change_duration: float

var _speed: float
var _direction: Vector2

signal wind_changed(speed:float, direction:Vector2)

func _ready() -> void:
	schedule_next_time_change()
	randomize_wind()

func randomize_wind() -> void:
	_speed = randf_range(min_speed, max_speed)
	_direction = Vector2(1,0).rotated(randf_range(0, PI*2))
	wind_changed.emit(_speed, _direction)

func set_wind(speed: float, direction: Vector2) -> void:
	_speed = speed
	_direction = direction.normalized()
	wind_changed.emit(_speed, _direction)
	
func _physics_process(delta: float) -> void:
	for affected_object in get_tree().get_nodes_in_group("wind_affected"):
		if affected_object is RigidBody2D:
			if affected_object.linear_velocity.length() < _speed:
				affected_object.apply_central_force(_direction * _speed)
		
		if affected_object is CharacterBody2D:
			var prev_velocity: Vector2 = affected_object.velocity
			affected_object.velocity = Vector2(1,0).rotated(affected_object.rotation) * _direction.rotated(-affected_object.rotation).x * _speed * delta * 60
			affected_object.move_and_slide()
			affected_object.velocity = prev_velocity

func schedule_next_time_change() -> void:
	$WindChangeTimer.start(randf_range(min_change_duration, max_change_duration))
