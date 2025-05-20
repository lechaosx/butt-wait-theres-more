@tool class_name PlayerShip extends CharacterBody2D

signal max_health_updated
signal health_updated
signal cargo_updated

@export var world: Node:
	set(value):
		world = value
		if not is_node_ready(): await ready
		%Cannon.world = value
		%SideCannons.world = value
		%BarrelDropping.world = value
		
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
		projectile_damage = value
		if not is_node_ready(): await ready
		$SideCannons.projectile_damage = value
		$Cannon.projectile_damage = value

@export var cannon_cooldown: float:
	set(value):
		if not is_node_ready(): await ready
		$CannonTimer.wait_time = value
	get: return $CannonTimer.wait_time
	
@export var barrel_cooldown: float:
	set(value):
		if not is_node_ready(): await ready
		$BarrelDropping.interval = value
	get: return $BarrelDropping.interval

@export var projectile_piercing: float:
	set(value):
		projectile_piercing = value
		if not is_node_ready(): await ready
		$SideCannons.projectile_piercing = value
		$Cannon.projectile_piercing = value
		
@export_range(0, 5) var side_cannon_pairs: int = 0:
	set(value):
		if not is_node_ready(): await ready
		%SideCannons.pairs = value
	get: return %SideCannons.pairs

var cargo: int:
	set(value):
		cargo = value
		cargo_updated.emit()

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
	
	if %HealthComponent.health <= 0:
		%CannonTimer.stop()
