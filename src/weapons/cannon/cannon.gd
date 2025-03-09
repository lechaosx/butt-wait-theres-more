extends Node2D

@onready var cannon_ball = preload("res://src/projectiles/cannon_ball/cannon_ball.tscn")

var velocity: Vector2
var previous_position: Vector2

@export var ball_speed = 40000
@export var cannon_heat_max : int = 1
@export var cannon_cooldown_time : float = 0.5

var cannon_heat : int 
var cannon_cooldown : float 

var level = 0

func _ready() -> void:
	previous_position = global_position

func level_up():
	if level >= 5:
		return

	level += 1
	cannon_heat_max += 1
	
func can_fire() -> bool:
	return cannon_heat < cannon_heat_max
	
func fire():
	if cannon_heat < cannon_heat_max:
		cannon_heat += 1
		
		var instance = cannon_ball.instantiate()
		instance.position = global_position + global_transform.x * $Sprite2D.texture.get_width()
		instance.scale = Vector2(0.5, 0.5)
		instance.add_collision_exception_with(get_parent())
		instance.apply_force(ball_speed * global_transform.x + velocity)
		get_tree().get_root().add_child(instance)
	
		if $Timer.is_stopped():
			$Timer.start()
			
func _process(delta: float) -> void:
	velocity = (global_position - previous_position) / delta
	previous_position = global_position
	
	var color_change =  lerp(1.0, 0.0, float(cannon_heat) / float(cannon_heat_max))
	$Sprite2D.modulate = Color(1, color_change, color_change)


func _on_timer_timeout() -> void:
	if cannon_heat > 0:
		cannon_heat -= 1
	
	if cannon_heat > 0:
		$Timer.start()
