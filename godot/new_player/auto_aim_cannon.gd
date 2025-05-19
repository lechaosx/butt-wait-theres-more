@tool extends Node2D

@export var world: Node
@export var parent: CharacterBody2D

@export var target_groups: Array[String] = []
@export var friendly_groups: Array[String] = []

@export var speed: int = 600
@export var damage: int = 1
@export var piercing: int = 0

@export var view_range: int = 500:
	set(value):
		if not is_node_ready(): await ready
		$DetectionArea/CollisionShape2D.shape.radius = value
	get: return $DetectionArea/CollisionShape2D.shape.radius

func _targetable(node: Node) -> bool:
	for group in target_groups:
		if node.is_in_group(group):
			return true
	return false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if not world: warnings.append("World is not set!")
	if not parent: warnings.append("Parent is not set!")
	return warnings

func _get_nearest_target() -> Node2D:
	var target: Node2D
	
	var min_distance: float = view_range
	for body: Node2D in $DetectionArea.get_overlapping_bodies():
		if _targetable(body):
			var distance := global_position.distance_to(body.global_position)
			if distance <= min_distance:
				min_distance = distance
				target = body
				
	return target
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	var target := _get_nearest_target()
	if target:
		# TODO Predictive aiming
		global_rotation = (target.global_position - global_position).angle()
	else:
		rotation = 0

func _on_timer_timeout() -> void:
	var instance := preload("res://projectiles/cannon_ball/cannon_ball.tscn").instantiate()
	instance.global_position = $Barrel.global_position
	
	instance.damage = damage
	instance.piercing = piercing
	
	instance.friendly_groups = friendly_groups

	instance.linear_velocity = speed * Vector2.RIGHT.rotated(global_rotation)
	
	if parent:
		instance.linear_velocity += parent.velocity
		instance.add_collision_exception_with(parent)
		
	if world:
		world.add_child(instance)
	else:
		get_tree().root.add_child(instance)
		
	$AudioStreamPlayer2D.play()
