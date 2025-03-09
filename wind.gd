class_name Wind
extends Node

var _rng = RandomNumberGenerator.new()
var _direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	print_debug("https://www.youtube.com/watch?v=n4RjJKxsamQ")

func _physics_process(delta: float) -> void:
	_direction += Vector2(randf_range(-10, 10) * delta, randf_range(-10, 10) * delta)
	
	var affected_objects = get_tree().get_nodes_in_group("wind_affected")
	for affected_object in affected_objects:
		if affected_object is RigidBody2D:
			affected_object.apply_central_force(_direction)
		
		if affected_object is CharacterBody2D:
			var save_velocity = affected_object.velocity
			affected_object.velocity = Vector2(1,0).rotated(affected_object.rotation) * _direction.rotated(-affected_object.rotation).x * delta * 60
			affected_object.move_and_slide()
			affected_object.velocity = save_velocity
