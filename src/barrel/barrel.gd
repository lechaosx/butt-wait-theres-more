class_name Barrel extends RigidBody2D

@export var sink_down_time: float = 0.25
@export var rise_up_time: float = 0.5

var sink_direction: int = 0 ## -1 = sink down, +1 = rise up

func _ready() -> void:
	_rise_up()

func _process(_delta: float) -> void:
	if not $Timer.is_stopped():
		var sink_scale = ($Timer.time_left / $Timer.wait_time)
		if sink_direction == -1:
			$Sprite2D.scale = Vector2(sink_scale, sink_scale)
		elif  sink_direction == +1:
			$Sprite2D.scale = Vector2(1 - sink_scale, 1 - sink_scale)

func _update_fire() -> void:
	var desired_fire_count = $HealthComponent.max_hitpoints - $HealthComponent.hitpoints

	while %FireContainer.get_child_count() < desired_fire_count:
		var fire = preload("res://src/barrel/barrel_fire.tscn").instantiate()
		fire.frame = randi_range(0, 1)
		fire.position = Vector2(randi_range(-13, +13), randi_range(-18, +3))
		%FireContainer.add_child(fire)

	while %FireContainer.get_child_count() > desired_fire_count:
		%FireContainer.get_child(0).queue_free()
		
func _rise_up() -> void:
	$Sprite2D.scale = Vector2.ZERO
	sink_direction = +1
	$Timer.start(rise_up_time)

func _sink_down() -> void:
	$Sprite2D.scale = Vector2(1, 1)
	sink_direction = -1
	$Timer.start(sink_down_time)

func _explode() -> void:
	for body in $Area2D.get_overlapping_bodies():
		for component in body.get_children():
			if component is HealthComponent:
				component.hitpoints -= 10 # Could be based off square distance or something

func _on_health_component_died() -> void:
	# when animation finished, it will remove barrel
	var ee_barel = $Effects/EndExplosion
	var remove_barrel = func():
		queue_free()
	ee_barel.visible = true
	ee_barel.animation_finished.connect(remove_barrel)
	ee_barel.play("default")
	_explode()

func _on_health_component_hitpoints_updated() -> void:
	_update_fire()

func _on_health_component_max_hitpoints_updated() -> void:
	_update_fire()
