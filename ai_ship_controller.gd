class_name AIShipController extends Node

@export var target: Node2D

func get_acceleration_strength() -> float:
	return 1
	
func get_brake_strength() -> float:
	return 0

func get_steer_axis() -> float:
	if not target:
		return 0
		
	var forward: Vector2 = get_parent().transform.x.normalized()
	var to_target: Vector2 = target.position - get_parent().position
	
	return sign(forward.cross(to_target))
