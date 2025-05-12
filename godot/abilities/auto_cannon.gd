@tool extends Node2D

@export var sea: Sea
@export var body: CharacterBody2D

@export var ball_speed: int = 40000
@export var projectile_damage: int = 1

@export var piercing: int = 0
@export var interval: float:
	set(value):
		interval = value
		
		if not is_node_ready(): await ready
		
		$Timer.stop()
		if interval > 0:
			$Timer.wait_time = interval
			$Timer.start()
	
func _on_timer_timeout() -> void:
	if Engine.is_editor_hint():
		return
		
	var instance := preload("res://projectiles/cannon_ball/cannon_ball.tscn").instantiate()
	instance.damage = projectile_damage
	instance.piercing = piercing
	instance.position = global_position + global_transform.x * $Sprite2D.texture.get_width()
	instance.scale = Vector2(0.5, 0.5)
	instance.add_collision_exception_with(body)
	instance.apply_force(ball_speed * global_transform.x + body.velocity)
	sea.add_child(instance)
	
	$AudioStreamPlayer2D.play()
