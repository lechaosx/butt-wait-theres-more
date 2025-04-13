extends Node2D

@export var sea: Sea
@export var body: CharacterBody2D

@export var ball_speed: int = 40000
@export var projectile_damage: int = 1

@export var interval: float:
	set(value):
		if not is_node_ready():
			await ready # Sorry for this, but the setter is called before the object is ready...
		
		$Timer.stop()
		$Timer.wait_time = value
		if $Timer.wait_time > 0.0:
			$Timer.start()
	get:
		return $Timer.wait_time

var piercing: int = 0

func _on_timer_timeout() -> void:
	var instance := preload("res://projectiles/cannon_ball/cannon_ball.tscn").instantiate()
	instance.damage = projectile_damage
	instance.piercing = piercing
	instance.position = global_position + global_transform.x * $Sprite2D.texture.get_width()
	instance.scale = Vector2(0.5, 0.5)
	
	if body is Ship:
		instance.from_good_ship = body.is_good(body.type)
	
	instance.add_collision_exception_with(body)
	instance.apply_force(ball_speed * global_transform.x + body.velocity)
	sea.add_child(instance)
	
	$AudioStreamPlayer2D.play()
