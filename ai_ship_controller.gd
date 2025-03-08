class_name AIShipController extends Node

@export var target: Node2D

func _ready() -> void:
	get_parent().set_collision_mask_value(4, true)

func get_acceleration_strength():
	return 1
	
func get_brake_strength():
	return 0

func get_steer_axis():
	var forward = get_parent().transform.x.normalized()
	var to_target = target.position - get_parent().position
	
	return sign(forward.cross(to_target))
