class_name AIShipFollowerController extends Node

@export var owner_ship : Node2D

@export var range = 300
@export var offset_range = 100
@export var offset_rotation = 0;
@export var break_dist = 15;

var enemy_target : Node2D

var target

func _ready() -> void:
	offset_rotation = randf_range(-PI, PI)


func get_acceleration_strength():
	# we are assuming that get_acceleration_strength gets called fist lol
	target = get_target()
	var to_target : Vector2 = get_parent().position - target
	
	if to_target.length() <= break_dist && !enemy_target:
		return 0
	else:
		return 1
	
func get_brake_strength():
	var to_target : Vector2 = get_parent().position - target
	
	if to_target.length() <= break_dist && !enemy_target:
		return 1
	else:
		return 0

func get_steer_axis():
	var forward = get_parent().transform.x.normalized()
	var to_target = target - get_parent().position
	return sign(forward.cross(to_target))
	
func get_target():
	if !enemy_target:
		var enemies = get_tree().get_nodes_in_group("enemies")
		
		for enemy in enemies:
			if (enemy.transform.get_origin() - owner_ship.transform.get_origin()).length() <= range:
				enemy_target = enemy
				break
		
	if !enemy_target:
		return owner_ship.transform.get_origin() + Vector2(-offset_range, 0).rotated(offset_rotation).rotated(owner_ship.transform.get_rotation())
	else:
		return enemy_target.transform.get_origin()
