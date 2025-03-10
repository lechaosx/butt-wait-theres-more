extends Node

@export var range = 500
@export var target_group: String = "enemies"

var last_target
var last_target_position

func _process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group(target_group)
		
	var min_dist = range
	var target : Node2D
	for enemy in enemies:
		var len = (enemy.global_position - get_parent().global_position).length()
		if len <= range && len <= min_dist:
			min_dist = len
			target = enemy
	
	if not target:
		return
	
	if last_target != target:
		last_target = target
		last_target_position = target.global_position
		return
	
	var target_velocity = target.global_position - last_target_position 
	last_target_position = target.global_position
	
	var ball_speed = 10 # this is experimental value, just bulgarian constant xD
	var shooting_vector = target.global_position + target_velocity * min_dist / ball_speed  - get_parent().global_position
	
	get_parent().global_rotation = shooting_vector.angle()
	get_parent().fire()
	
	
	
