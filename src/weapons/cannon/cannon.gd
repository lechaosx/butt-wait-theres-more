extends Node2D

var cannon_ball = preload("res://src/projectiles/cannon_ball/cannon_ball.tscn")

var loc_diff : Vector2
const ball_speed = 10000

func _input(event):
	pass
	if event.is_action_pressed("Click"):
		var instance = cannon_ball.instantiate()
		instance.apply_force(loc_diff.normalized() * ball_speed)
		instance.transform = get_parent().transform.translated(loc_diff.normalized() * $Sprite2D.position.x)
		get_tree().root.add_child(instance);
		

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var local_pos = get_global_transform_with_canvas()
	
	# set Rotation
	loc_diff = mouse_pos - local_pos.origin 
	rotation = loc_diff.angle() - get_parent().rotation
		
