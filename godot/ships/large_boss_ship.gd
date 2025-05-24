@tool class_name LargeBossShip extends CharacterBody2D

@export var world: Node:
	set(value):
		world = value
		if not is_node_ready(): await ready
		$Cannon1.world = world
		$Cannon2.world = world
		$Cannon3.world = world
		$Cannon4.world = world
		$Cannon5.world = world
		$Cannon6.world = world
		$Cannon7.world = world
		$Cannon8.world = world
		$Cannon9.world = world
		$Cannon10.world = world
		$Cannon11.world = world

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
		
@export var target: Node2D

var cargo: int = 5

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
		$CannonTimer.stop()
		remove_child($RamArea)
		
		remove_from_group("enemies")
		
		$SinkDownTimer.start()
		
		await $SinkDownTimer.timeout
			
		queue_free()
		
		for i in range(cargo):
			var cargo_box := preload("res://cargo.tscn").instantiate()
			cargo_box.global_position = global_position
			add_sibling(cargo_box)
