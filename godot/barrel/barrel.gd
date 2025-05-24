@tool class_name Barrel extends RigidBody2D

@export var rise_up_time : float:
	set(value):
		if not is_node_ready(): await ready
		$RiseTimer.wait_time = value
	get: return $RiseTimer.wait_time

@export var health: int:
	set(value):
		if not is_node_ready(): await ready
		$HealthComponent.health = value
	get: return $HealthComponent.health
	
func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	$Sprite2D.scale = Vector2(0, 0)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if not $RiseTimer.is_stopped():
		var sink_scale: float = ($RiseTimer.time_left / $RiseTimer.wait_time)
		$Sprite2D.scale = Vector2(1 - sink_scale, 1 - sink_scale)

func _update_fire() -> void:
	var desired_fire_count: int = lerp(5, 0, 1.0 * $HealthComponent.health / $HealthComponent.max_health)

	while %FireContainer.get_child_count() < desired_fire_count:
		var fire := preload("res://barrel/barrel_fire.tscn").instantiate()
		fire.frame = randi_range(0, 1)
		fire.position = Vector2(randi_range(-13, +13), randi_range(-18, +3))
		%FireContainer.add_child(fire)

	var excess := %FireContainer.get_child_count() - desired_fire_count
	if excess > 0:
		for i in range(excess):
			%FireContainer.get_child(i).queue_free()
			
func _on_health_component_health_updated() -> void:
	if Engine.is_editor_hint():
		return
		
	_update_fire()

	if $HealthComponent.health <= 0:
		$DetonationTimer.start()
		
		await $DetonationTimer.timeout
		
		var explosion := preload("res://explosion.tscn").instantiate()
		explosion.global_position = global_position
		add_sibling(explosion)
		
		queue_free()

func _on_health_component_max_health_updated() -> void:
	if Engine.is_editor_hint():
		return
		
	_update_fire()
