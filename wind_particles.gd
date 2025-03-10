class_name WindParticles
extends Node2D

@onready var wind_particle_scn = preload("res://wind_particle.tscn")
# @onready var wind2 = preload("res://assets/Effects/wind2.png")
# @onready var wind3 = preload("res://assets/Effects/wind3.png")
# @onready var wind4 = preload("res://assets/Effects/wind4.png")

@export var spawn_interval = 0.005
@export var total_count = 200
@export var effect_area = Vector2(1280, 720) * 2
@export var base_speed = 50

var _speedCoef = 1
var _direction = Vector2(1, 0)
var _pool: Array[Sprite2D] = []
var _active: Array[Sprite2D] = []
var _waited_time = 0
var _spawn_position = Vector2(0, 0)

func _ready() -> void:
	%Wind.wind_changed.connect(set_wind)
	
	for i in range(total_count):
		var particle = wind_particle_scn.instantiate()
		add_child(particle)
		_pool.append(particle)
		particle.visible = false
		particle.modulate = Color(1, 1, 1, randf_range(0.2, 0.4))
		particle.scale.x = randf_range(0.3, 0.8)
		particle.scale.y = randi_range(-1, 1)
		if particle.scale.y == 0:
			particle.scale.y = 1

func set_wind(speed: float, direction: Vector2) -> void:
	_speedCoef = speed
	_direction = direction

func _process(delta: float) -> void:
	_spawn_position = %PlayerShip.position - 0.4 * sign(_direction) * effect_area
	print_debug(_active.size())
	for particle :WindParticle in _active:
		if !particle.is_visible_on_screen():
			# calculate if particle direction is away from player
			var l1 = (particle.position - %PlayerShip.position).length()
			var l2 = (particle.position + particle._direction - %PlayerShip.position).length()
			if l2 > l1:
				particle.visible = false
				_pool.append(particle)
				_active.erase(particle)
	
	_waited_time += delta
	var max_spawn_count = _waited_time / spawn_interval
	
	for i in range(randi_range(0, max_spawn_count)):
		if len(_pool) == 0:
			break
	
		_waited_time = 0
		var particle = _pool.pop_back()
		_active.append(particle)
		var pos = _spawn_position + _direction.orthogonal() * randf_range(-effect_area.x, effect_area.x)
		particle.reset(pos, _speedCoef * base_speed, _direction)
		
