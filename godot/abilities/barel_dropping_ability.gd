extends Node

@export var sea: Sea

var level: int = 0

func level_up() -> void:
	if level >= 5:
		return

	level += 1

	$Timer.wait_time = 5.0 / level

	if level == 1:
		$Timer.start()

func _on_timer_timeout() -> void:
	var instance := preload("res://projectiles/barrel_ball/barrel_ball.tscn").instantiate()

	var ship: Ship = get_parent()
	var pos := ship.global_position + Vector2(-100, 0).rotated(ship.global_rotation)
	var dir := -1 * ship.global_transform.x
	var speed := 4000 #hardcoded:40000
	var offset := 20 #hardcoded:20

	instance.position = pos + ship.global_transform.x * offset
	instance.add_collision_exception_with(ship)
	instance.apply_force(speed * dir + ship.velocity)

	sea.add_child(instance)
