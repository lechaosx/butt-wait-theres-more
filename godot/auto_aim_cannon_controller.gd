@tool class_name AutoAimCannonController extends Area2D

@export var cannon: Cannon

@export var view_range: int:
	set(value):
		if not is_node_ready(): await ready
		$CollisionShape2D.shape.radius = value
	get: return $CollisionShape2D.shape.radius
	
@export var target_group: String = "enemies"

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if not view_range: warnings.append("Cannon is not set!")
	return warnings

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	var min_distance: float = view_range
	var target: Node2D
	for enemy in get_overlapping_bodies():
		if enemy.is_in_group(target_group):
			var distance: float = cannon.global_position.distance_to(enemy.global_position)
			if distance <= min_distance:
				min_distance = distance
				target = enemy
				
	if target:
		cannon.global_rotation = cannon.global_position.direction_to(target.global_position).angle()
	else:
		cannon.rotation = 0
