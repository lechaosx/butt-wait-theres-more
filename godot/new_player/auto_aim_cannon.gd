extends Node2D

@export var world: Node = self
@export var owning_body: CharacterBody2D

@export var view_range: int = 500
@export var target_group: String = "enemies"

@export var ball_speed: int = 40000
@export var projectile_damage: int = 1
@export var piercing: int = 1

func _get_nearest_target() -> Node2D:
	var target: Node2D
	
	var min_distance: float = view_range
	for body: Node2D in $Area2D.get_overlapping_bodies():
		if body.is_in_group(target_group):
			var distance: float = (body.global_position - global_position).length()
			if distance <= min_distance:
				min_distance = distance
				target = body
				
	return target

func _process(_delta: float) -> void:
	var target := _get_nearest_target()

	if not target:
		rotation = 0
		return
	
	var ball_speed: float = 10 # this is experimental value, just bulgarian constant xD
	
	global_rotation = global_position.direction_to(target.global_position + target.velocity * global_position.distance_to(target.global_position) / ball_speed).angle()

func _on_timer_timeout() -> void:
	var instance := preload("res://projectiles/cannon_ball/cannon_ball.tscn").instantiate()
	instance.damage = projectile_damage
	instance.piercing = piercing
	instance.position = global_position + global_transform.y * $Sprite2D.texture.get_width()
	instance.scale = Vector2(0.5, 0.5)
	
	if get_parent() is Ship:
		instance.from_good_ship = get_parent().is_good(get_parent().type)
	
	instance.add_collision_exception_with(get_parent())
	instance.apply_force(ball_speed * global_transform.y)
	
	if owning_body:
		instance.apply_force(owning_body.velocity)
	
	world.add_child(instance)
