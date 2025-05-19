@tool extends Node

@export var world: Node
@export var parent: CharacterBody2D

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

	var pos := parent.global_position + Vector2(-100, 0).rotated(parent.global_rotation)
	var dir := -1 * parent.global_transform.x
	var speed := 4000 #hardcoded:40000
	var offset := 20 #hardcoded:20

	instance.position = pos + parent.global_transform.x * offset
	instance.add_collision_exception_with(parent)
	instance.apply_force(speed * dir + parent.velocity)

	world.add_child(instance)
