class_name Cannon extends Node2D

@export var sea: Sea

@export var ball_speed: int = 40000
@export var default_cannon_cooldown_time: float = 2
@export var cannon_cooldown_variation: float = 0.1
@export var autofire: bool = false

@export var cannon_cooldown_time: float = 0.5
@export var projectile_damage: int = 1

var can_fire: bool = true

var _velocity: Vector2
var _previous_position: Vector2

var level: int = 0
var piercing: int = 0

func _ready() -> void:
	_previous_position = global_position
	$Timer.wait_time = default_cannon_cooldown_time + cannon_cooldown_variation * randf()
	


func _process(_delta: float) -> void:
	if can_fire && autofire:
		fire()

func level_up() -> void:
	if level >= 5:
		return

	level += 1
	
	$Timer.wait_time = default_cannon_cooldown_time - (default_cannon_cooldown_time / 6) * level
	
func level_up_piercing() -> void:
	if piercing >= 5:
		return

	piercing += 1
	
func fire() -> void:
	if not can_fire:
		return
		
	can_fire = false
		
	var instance := preload("res://projectiles/cannon_ball/cannon_ball.tscn").instantiate()
	instance.damage = projectile_damage
	instance.piercing = piercing
	instance.position = global_position + global_transform.x * $Sprite2D.texture.get_width()
	instance.scale = Vector2(0.5, 0.5)
	
	if get_parent() is Ship:
		instance.from_good_ship = get_parent().is_good(get_parent().type)
	
	instance.add_collision_exception_with(get_parent())
	instance.apply_force(ball_speed * global_transform.x + _velocity)
	sea.add_child(instance)
	
	$AudioStreamPlayer2D.play()
	
	if $Timer.is_stopped():
		$Timer.start()
			
func _physics_process(delta: float) -> void:
	_velocity = (global_position - _previous_position) / delta
	_previous_position = global_position

func _on_timer_timeout() -> void:
	can_fire = true
	if autofire:
		fire()
