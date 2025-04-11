extends Node

@export var view_range: int = 500
@export var target_group: String = "enemies"

var last_target: Node2D
var last_target_position: Vector2

func _process(_delta: float) -> void:
	var min_distance: float = view_range
	var target: Node2D
	for enemy in get_tree().get_nodes_in_group(target_group):
		var distance: float = (enemy.transform.get_origin() - get_parent().global_position).length()
		if distance <= min_distance:
			min_distance = distance
			target = enemy
	
	if not target:
		return
	
	if last_target != target:
		last_target = target
		last_target_position = target.global_position
		return
	
	var target_velocity := target.global_position - last_target_position 
	last_target_position = target.global_position
	
	var ball_speed: float = 10 # this is experimental value, just bulgarian constant xD
	var shooting_vector: Vector2 = target.global_position + target_velocity * min_distance / ball_speed  - get_parent().global_position
	
	get_parent().global_rotation = shooting_vector.angle()
	get_parent().fire()
	
	
	
