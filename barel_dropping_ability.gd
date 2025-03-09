extends Node

@onready var barrel_scene := preload("res://src/barrel/barrel.tscn")

var level = 0

func level_up():
	if level >= 5:
		return
		
	level += 1
	
	$Timer.wait_time = 5 / level
	
	if level == 1:
		$Timer.start()

func _on_timer_timeout() -> void:
	var barrel = barrel_scene.instantiate();
	barrel.position = get_parent().global_position + Vector2(-100, 0).rotated(get_parent().global_rotation)
	get_tree().get_root().add_child(barrel)
