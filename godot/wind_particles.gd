class_name WindParticles
extends Node2D

@export var spawn_interval: float = 0.005
@export var total_count: int = 400
@export var effect_area := Vector2(1280, 720) * 2
@export var base_speed: float = 50

var _speedCoef: float = 1.0
var _direction := Vector2(1, 0)
var _pool: Array[Sprite2D] = []
var _active: Array[Sprite2D] = []
var _waited_time: float = 0.0
var _spawn_position := Vector2(0, 0)

var target_direction: Vector2
var target_speed: float

var speed_delta: float = 0.1
var rotation_delta: float = 0.05

func _ready() -> void:
	for i in range(total_count):
		var particle := preload("res://wind_particle.tscn").instantiate()
		add_child(particle)
		_pool.append(particle)
		particle.visible = false
		particle.modulate = Color(1, 1, 1, randf_range(0.2, 0.4))
		particle.scale.x = randf_range(0.3, 0.8)
		particle.scale.y = randi_range(-1, 1)
		if particle.scale.y == 0:
			particle.scale.y = 1

func set_wind(speed: float, direction: Vector2) -> void:
	if not target_speed:
		_speedCoef = speed
		_direction = direction
	target_speed = speed
	target_direction = direction

func _process(delta: float) -> void:
	if target_speed and _speedCoef != target_speed:
		_speedCoef += clamp(target_speed-_speedCoef, -speed_delta, speed_delta)
		
	if target_direction and _direction != target_direction:
		_direction = _direction.rotated(clamp(_direction.angle_to(target_direction), -rotation_delta, rotation_delta))
	
	_spawn_position = %PlayerShip.position - 0.4 * sign(_direction) * effect_area
	for particle: WindParticle in _active:
		particle.change_direction(_speedCoef * base_speed, _direction)
		
		if !particle.is_visible_on_screen():
			# calculate if particle direction is away from player
			var l1: float = (particle.position - %PlayerShip.position).length()
			var l2: float = (particle.position + particle._direction - %PlayerShip.position).length()
			if l2 > l1:
				particle.visible = false
				_pool.append(particle)
				_active.erase(particle)
	
	_waited_time += delta
	var max_spawn_count := int(_waited_time / spawn_interval)
	
	for i in range(randi_range(0, max_spawn_count)):
		if len(_pool) == 0:
			break
	
		_waited_time = 0
		var particle: WindParticle = _pool.pop_back()
		_active.append(particle)
		var pos := _spawn_position + _direction.orthogonal() * randf_range(-effect_area.x, effect_area.x)
		particle.reset(pos, _speedCoef * base_speed, _direction)
