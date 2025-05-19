class_name Barrel extends RigidBody2D

@export var sink_down_time: float = 0.25
@export var rise_up_time: float = 0.5
@export var max_fire_count: int = 5

var sink_direction: int = 0 ## -1 = sink down, +1 = rise up

func _ready() -> void:
	_rise_up()

func _process(_delta: float) -> void:
	if not $Timer.is_stopped():
		var sink_scale: float = ($Timer.time_left / $Timer.wait_time)
		if sink_direction == -1:
			$Sprite2D.scale = Vector2(sink_scale, sink_scale)
		elif  sink_direction == +1:
			$Sprite2D.scale = Vector2(1 - sink_scale, 1 - sink_scale)

func _update_fire() -> void:
	var desired_fire_count: int = lerp(max_fire_count, 0, 1.0 * $HealthComponent.health / $HealthComponent.max_health)

	while %FireContainer.get_child_count() < desired_fire_count:
		var fire := preload("res://barrel/barrel_fire.tscn").instantiate()
		fire.frame = randi_range(0, 1)
		fire.position = Vector2(randi_range(-13, +13), randi_range(-18, +3))
		%FireContainer.add_child(fire)

	var excess := %FireContainer.get_child_count() - desired_fire_count
	if excess > 0:
		for i in range(excess):
			%FireContainer.get_child(i).queue_free()
			
func _rise_up() -> void:
	$Sprite2D.scale = Vector2.ZERO
	sink_direction = +1
	$Timer.start(rise_up_time)

func _sink_down() -> void:
	$Sprite2D.scale = Vector2(1, 1)
	sink_direction = -1
	$Timer.start(sink_down_time)

func _on_health_component_health_updated() -> void:
	_update_fire()

	if $HealthComponent.health <= 0:
		$DetonationTimer.start()

func _on_health_component_max_health_updated() -> void:
	_update_fire()
	
func _on_detonation_timer_timeout() -> void:
	$EndExplosion.visible = true
	$EndExplosion.animation_finished.connect(_explode)
	$EndExplosion.play("default")

func _explode() -> void:
	for body: Node2D in %ExplosionArea.get_overlapping_bodies():
		for component: Node in body.get_children():
			if component is HealthComponent:
				component.health -= 10 # Could be based off square distance or something\
	
	queue_free()
