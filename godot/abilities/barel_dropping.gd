@tool extends Node

@export var sea: Sea
@export var body: CharacterBody2D

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
		
	var instance := preload("res://projectiles/barrel_ball/barrel_ball.tscn").instantiate()

	var pos := body.global_position + Vector2(-100, 0).rotated(body.global_rotation)
	var dir := -1 * body.global_transform.x
	var speed := 4000 #hardcoded:40000
	var offset := 20 #hardcoded:20

	instance.position = pos + body.global_transform.x * offset
	instance.add_collision_exception_with(body)
	instance.apply_force(speed * dir + body.velocity)

	sea.add_child(instance)
