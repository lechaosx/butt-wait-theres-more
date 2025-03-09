extends Node2D

var cannon_ball = preload("res://src/projectiles/cannon_ball/cannon_ball.tscn")

var loc_diff : Vector2

@export var ball_speed = 40000
@export var cannon_heat_max : int = 5
@export var cannon_cooldown_time : float = 0.5

@export var projectile_damage: int
@export var projectile_piercing: int

var cannon_heat : int 
var cannon_cooldown : float 

func _input(event):
	pass
	if event.is_action_pressed("Click") && cannon_heat <= cannon_heat_max:
		cannon_heat += 1
		var instance:CannonBall = CannonSpawn.spawn_cannon_ball(get_parent(), ball_speed, get_parent().transform.get_origin(), loc_diff.normalized(), get_parent().velocity, $Sprite2D.position.x)
		instance.damage = projectile_damage
		instance.piercing = projectile_piercing
		get_tree().root.add_child(instance)

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var local_pos = get_global_transform_with_canvas()
	
	# set Rotation
	loc_diff = mouse_pos - local_pos.origin 
	rotation = loc_diff.angle() - get_parent().rotation
	
	cannon_cooldown += delta
	if cannon_cooldown >= cannon_cooldown_time:
		cannon_cooldown = 0
		if cannon_heat > 0:
			cannon_heat -= 1
	
	var color_change =  1.0 - (float(cannon_heat) / float(cannon_heat_max)) * 0.5
	$Sprite2D.modulate = Color( 1, color_change, color_change)
