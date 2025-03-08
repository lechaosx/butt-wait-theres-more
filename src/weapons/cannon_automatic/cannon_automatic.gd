class_name CannonAutomatic extends Node2D

var cannon_ball = preload("res://src/projectiles/cannon_ball/cannon_ball.tscn")

# in seconds
@export var cooldown = 3

@export var ball_speed = 40000

var velocity: Vector2
var previous_position: Vector2

func _ready() -> void:
	$Timer.start(cooldown)
	previous_position = global_position
	
func _physics_process(delta: float) -> void:
	velocity = (global_position - previous_position) / delta
	previous_position = global_position

func _on_timer_timeout() -> void:
	# refresh cooldown if it changed
	$Timer.wait_time = cooldown

	var forward_dir = global_transform.x
	
	var instance = CannonSpawn.spawn_cannon_ball(get_parent(), ball_speed, global_position, forward_dir, velocity, 20)
	get_tree().root.add_child(instance)
