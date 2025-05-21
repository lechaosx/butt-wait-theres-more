@tool class_name EnemyShip extends CharacterBody2D

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

@export var target: Node2D

var cargo: int = 1

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if %HealthComponent.health > 0:
		%ShipMovementComponent.acceleration_intent = 1
		%ShipMovementComponent.steer_intent = sign(Vector2.RIGHT.rotated(global_rotation).cross(global_position.direction_to(target.global_position)))
	else:
		%ShipMovementComponent.acceleration_intent = 0.0
		%ShipMovementComponent.steer_intent = 0.0

func _on_ram_area_body_entered(body: Node2D) -> void:
	if %HealthComponent.health > 0 and "health" in body:
		body.health -= 1

func _on_health_component_health_updated() -> void:
	if %HealthComponent.health <= 0:
		remove_from_group("enemies")
		
		$SinkDownTimer.start()
		
		await $SinkDownTimer.timeout
			
		queue_free()
		
		for i in range(cargo):
			var cargo_box := preload("res://cargo.tscn").instantiate()
			cargo_box.global_position = global_position
			add_sibling(cargo_box)
