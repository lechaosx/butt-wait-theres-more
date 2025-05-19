@tool extends CharacterBody2D

signal max_health_updated
signal health_updated

@export var world: Node:
	set(value):
		if not is_node_ready(): await ready
		%AutoAimCannon.world = value
	get: return %AutoAimCannon.world
		
@export var max_health: int:
	set(value):
		if not is_node_ready(): await ready
		%HealthComponent.max_health = value
	get: return %HealthComponent.max_health

@export var health: int:
	set(value):
		if not is_node_ready(): await ready
		%HealthComponent.health = value
	get: return %HealthComponent.health

@export var power: int:
	set(value):
		if not is_node_ready(): await ready
		%ShipMovementComponent.power = value
	get: return %ShipMovementComponent.power

@export var brakes: int:
	set(value):
		if not is_node_ready(): await ready
		%ShipMovementComponent.brakes = value
	get: return %ShipMovementComponent.brakes

@export var steering: int:
	set(value):
		if not is_node_ready(): await ready
		%ShipMovementComponent.steering_angle = value
	get: return %ShipMovementComponent.steering_angle

@export var ramming_damage: int:
	set(value):
		if not is_node_ready(): await ready
		$RamArea.damage = value
	get: return $RamArea.damage
		
@export var projectile_damage: int:
	set(value):
		if not is_node_ready(): await ready
		$AutoAimCannon.damage = value
	get: return $AutoAimCannon.damage

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if not world: warnings.append("World is not set!")
	return warnings

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if %HealthComponent.health > 0:
		%ShipMovementComponent.acceleration_intent = Input.get_action_strength("ui_up")
		%ShipMovementComponent.brake_intent = Input.get_action_strength("ui_down")
		%ShipMovementComponent.steer_intent = Input.get_axis("ui_left", "ui_right")
	else:
		%ShipMovementComponent.acceleration_intent = 0.0
		%ShipMovementComponent.brake_intent = 0.0
		%ShipMovementComponent.steer_intent = 0.0

func _on_health_component_max_health_updated() -> void:
	max_health_updated.emit()
	
func _on_health_component_health_updated() -> void:
	health_updated.emit()
