extends Node

@export var view_range = 500
@export var target_group: String = "enemies"

func _process(_delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group(target_group)
		
	var min_distance = view_range
	var target : Node2D
	for enemy in enemies:
		var distance = (enemy.transform.get_origin() - get_parent().global_position).length()
		if distance <= min_distance:
			min_distance = distance
			target = enemy
			break
	
	if target:
		get_parent().global_rotation = (target.global_position - get_parent().global_position).angle()
		get_parent().fire()
