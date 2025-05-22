@tool class_name Cannon extends Node2D

@export var world: Node
@export var parent: CharacterBody2D

@export var projectile_speed: int = 600
@export var projectile_damage: int = 1
@export var projectile_piercing: int = 0

@export var enabled: bool = true:
	set(value):
		enabled = value
		visible = value
		set_physics_process(value)
		set_process(value)
		set_process_input(value)
		set_process_unhandled_input(value)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if not world: warnings.append("World is not set!")
	if not parent: warnings.append("Parent is not set!")
	return warnings
	
func fire() -> void:
	if not enabled:
		return
		
	var instance := preload("res://projectiles/cannon_ball/cannon_ball.tscn").instantiate()
	
	instance.damage = projectile_damage
	instance.piercing = projectile_piercing
	instance.position = $Marker2D.global_position
	
	instance.linear_velocity = projectile_speed * Vector2.RIGHT.rotated(global_rotation)
	
	if parent:
		instance.linear_velocity += parent.velocity
		instance.add_collision_exception_with(parent)
	
	if world:
		world.add_child(instance)
	else:
		get_tree().root.add_child(instance)
	
	$AudioStreamPlayer2D.play()
