class_name CannonAutomatic extends Node2D

# in seconds
@export var cooldown = 3

@export var ball_speed: int = 40000

var piercing = 1

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
	
	CannonSpawn.spawn_cannon_ball(get_parent(), ball_speed, global_position, forward_dir, get_parent().velocity, 20, piercing)
