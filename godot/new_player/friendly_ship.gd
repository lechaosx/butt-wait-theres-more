class_name FriendlyShip extends CharacterBody2D

@export var parent: Node2D

@export var target_group: String = "enemies"
@export var view_range: int = 800:
	set(value):
		if not is_node_ready():
			await ready
		
		%ViewArea/CollisionShape2D.shape.radius = value
		
	get: return %ViewArea/CollisionShape2D.shape.radius


func _get_target() -> Node2D:
	var bodies: Array[Node2D] = %ViewArea.get_overlapping_bodies()
	
	# Return to parent if too far
	if parent not in bodies:
		return parent
		
	var enemy: Node2D
	
	var min_distance: float = view_range
	for body in bodies:
		if body.is_in_group(target_group):
			var distance := global_position.distance_to(body.global_position)
			if distance <= min_distance:
				min_distance = distance
				enemy = body
	
	# Return to parent if no enemy in range
	if not enemy:
		return parent
		
	return enemy

func _physics_process(_delta: float) -> void:
	var target := _get_target()
	
	if target:
		%ShipMovementComponent.acceleration_intent = 1
		%ShipMovementComponent.brake_intent = 0
		%ShipMovementComponent.steer_intent = sign(transform.y.normalized().cross(target.global_position - global_position))
	else:
		%ShipMovementComponent.acceleration_intent = 0
		%ShipMovementComponent.brake_intent = 0
		%ShipMovementComponent.steer_intent = 0
