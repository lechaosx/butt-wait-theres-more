extends Node

@export var range = 500
@export var target_group: String = "enemies"

func _process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group(target_group)
		
	var min_dist = range
	var target : Node2D
	for enemy in enemies:
		var len = (enemy.transform.get_origin() - get_parent().global_position).length()
		if len <= range && len <= min_dist:
			min_dist = len
			target = enemy
			break
	
	if target:
		get_parent().global_rotation = (target.global_position - get_parent().global_position).angle()
		get_parent().fire()
