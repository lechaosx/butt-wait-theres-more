class_name CannonAutoaim extends Node2D

var cannon_ball = preload("res://src/projectiles/cannon_ball/cannon_ball.tscn")

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
		
	for enemy in enemies:
		if (enemy.transform.get_origin() - global_position).length() <= range:
			target = enemy
			break
	
	if target:
		rotation = (target.transform.get_origin() - global_position).angle() - get_parent().rotation
	else:
		rotation = 0

func _on_timer_timeout() -> void:
	# refresh cooldown if it changed
	$Timer.wait_time = cooldown

	if target:
		var forward_dir = global_transform.x
		var instance = cannon_ball.instantiate()
		instance.position = global_position + forward_dir * 20
		instance.scale = Vector2(0.5, 0.5)
		get_tree().root.add_child(instance)
		instance.apply_force(ball_speed * forward_dir + velocity)
