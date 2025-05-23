@tool class_name EnemyShip extends CharacterBody2D

@export var world: Node:
	set(value):
		world = value
		if not is_node_ready(): await ready
		$Cannon.world = world
		$RightCannon.world = world
		$LeftCannon.world = world

@export var max_health: int:
	set(value):
		if not is_node_ready(): await ready
		$HealthComponent.max_health = value
	get: return $HealthComponent.max_health

@export var health: int:
	set(value):
		if not is_node_ready(): await ready
		$HealthComponent.health = value
	get: return $HealthComponent.health

@export var central_cannon: bool:
	set(value):
		central_cannon = value
		if not is_node_ready(): await ready
		$Cannon.enabled = central_cannon
		$Cannon.visible = central_cannon

@export var side_cannons: bool:
	set(value):
		side_cannons = value
		if not is_node_ready(): await ready
		$LeftCannon.enabled = side_cannons
		$LeftCannon.visible = side_cannons
		$RightCannon.enabled = side_cannons
		$RightCannon.visible = side_cannons
		
@export var target: Node2D

var cargo: int = 1

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if not world: warnings.append("World is not set!")
	if not target: warnings.append("Target is not set!")
	return warnings

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if $HealthComponent.health > 0:
		$ShipMovementComponent.acceleration_intent = 1
		$ShipMovementComponent.steer_intent = sign(Vector2.RIGHT.rotated(global_rotation).cross(global_position.direction_to(target.global_position)))
	else:
		$ShipMovementComponent.acceleration_intent = 0.0
		$ShipMovementComponent.steer_intent = 0.0

func _on_health_component_health_updated() -> void:
	if $HealthComponent.health <= 0:
		remove_from_group("enemies")
		
		$SinkDownTimer.start()
		
		await $SinkDownTimer.timeout
			
		queue_free()
		
		for i in range(cargo):
			var cargo_box := preload("res://cargo.tscn").instantiate()
			cargo_box.global_position = global_position
			add_sibling(cargo_box)
