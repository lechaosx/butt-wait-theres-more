extends Node

@onready var barrel_projectile = preload("res://src/projectiles/barrel_ball/barrel_ball.tscn")

var level = 0

func level_up():
	if level >= 5:
		return

	level += 1

	$Timer.wait_time = 5 / level

	if level == 1:
		$Timer.start()

func _on_timer_timeout() -> void:
	var instance = barrel_projectile.instantiate()

	var ship: Ship = get_parent()
	var pos = ship.global_position + Vector2(-100, 0).rotated(ship.global_rotation)
	var dir = -1 * ship.global_transform.x
	var speed = 4000 #hardcoded:40000
	var offset = 20 #hardcoded:20

	instance.position = pos + ship.global_transform.x * offset
	instance.is_frendly = ship.is_good(ship.type)
	instance.add_collision_exception_with(ship)
	instance.apply_force(speed * dir + ship.velocity)

	get_tree().get_root().add_child(instance)
