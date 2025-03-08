class_name CannonAutoaim extends Node2D

# in seconds
@export var cooldown = 3

@export var ball_speed = 40000
@export var range = 500

var velocity: Vector2
var previous_position: Vector2

var target : Ship

func _ready() -> void:
	$Timer.start(cooldown)
	previous_position = global_position
	
func _physics_process(delta: float) -> void:
	velocity = (global_position - previous_position) / delta
	previous_position = global_position
	
	var enemies = get_tree().get_nodes_in_group("enemies")
		
	var min_dist = range
	var min_dist_target : Ship
	for enemy in enemies:
		var len = (enemy.transform.get_origin() - global_position).length()
		if len <= range && len <= min_dist:
			min_dist = len
			min_dist_target = enemy
			break
	
	if min_dist_target:
		target = min_dist_target
	
	if target:
		rotation = (target.transform.get_origin() - global_position).angle() - get_parent().rotation
	else:
		rotation = 0

func _on_timer_timeout() -> void:
	# refresh cooldown if it changed
	$Timer.wait_time = cooldown

	if target:
		var forward_dir = global_transform.x
		CannonSpawn.spawn_cannon_ball(get_parent(), ball_speed, global_position, forward_dir, velocity, 20)
