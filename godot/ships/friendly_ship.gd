@tool extends CharacterBody2D

@export var world: Node:
	set(value):
		if not is_node_ready(): await ready
		$Cannon.world = value
	get: return $Cannon.world
		
@export var parent: Node2D

@export var target_group: String = "enemies"

@export var view_range: int = 800:
	set(value):
		if not is_node_ready(): await ready
		%ViewArea/CollisionShape2D.shape.radius = value
	get: return %ViewArea/CollisionShape2D.shape.radius
	
func _get_enemy_target() -> Node2D:
	var bodies: Array[Node2D] = %ViewArea.get_overlapping_bodies()
	
	# Return to parent if too far
	if parent not in bodies:
		return null
		
	var enemy: Node2D
	
	var min_distance: float = view_range
	for body in bodies:
		if body.is_in_group(target_group):
			var distance := global_position.distance_to(body.global_position)
			if distance <= min_distance:
				min_distance = distance
				enemy = body
	
	return enemy

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var target := _get_enemy_target()

	if not target:
		target = parent
	
	$Cannon/Timer.paused = target == parent
	
	var just_rammed: bool  = target != parent and not $RamTimer.is_stopped()
	var parent_close: bool = target == parent and global_position.distance_to(parent.global_position) < 300
	
	if just_rammed or parent_close:
		%ShipMovementComponent.acceleration_intent = 0
		%ShipMovementComponent.steer_intent = 0
	else:
		%ShipMovementComponent.acceleration_intent = 1
		%ShipMovementComponent.steer_intent = sign(Vector2.RIGHT.rotated(global_rotation).cross(global_position.direction_to(target.global_position)))

func _on_ram_area_damaged(_body: Node2D) -> void:
	$RamTimer.start()
