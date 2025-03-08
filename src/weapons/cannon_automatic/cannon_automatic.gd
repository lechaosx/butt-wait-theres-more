extends Node2D

var cannon_ball = preload("res://src/projectiles/cannon_ball/cannon_ball.tscn")

# in seconds
@export var cooldown = 3

@export var ball_speed = 40000

func _ready() -> void:
	$Timer.start(cooldown)

func _on_timer_timeout() -> void:
	# refresh cooldown if it changed
	$Timer.wait_time = cooldown


	var rot = get_parent().transform.get_rotation() + transform.get_rotation()
	var forward : Vector2 = Vector2(1,0)
	var forward_dir = Vector2(cos(rot) * forward.x  - sin(rot) * forward.y, sin(rot) * forward.x  + cos(rot) * forward.y)
	
	var instance = cannon_ball.instantiate()
	# adding velocity to the offset due to movment offseting the spawn point
	instance.transform = get_parent().transform.translated(forward_dir * $Sprite2D.transform.x).translated(get_parent().velocity * 0.08)
	get_tree().root.add_child(instance)
	instance.apply_force(ball_speed * forward_dir + get_parent().velocity )
