class_name BackgroundRegion
extends Node2D

@onready var wave_scn = preload("res://wave.tscn")

@export var px_size: Vector2 = Vector2(1920, 1080)

var waves: Array[Sprite2D] = []
var wave_origins: Array[Vector2] = []

func _ready() -> void:
	var wave: Sprite2D = wave_scn.instantiate()
	var w = wave.texture.get_width()
	var h = wave.texture.get_height()
	
	var y_range = 0.5 * px_size.y * Vector2(-1, 1) + 0.5 * h * Vector2(1, -1)
	var x_range = 0.5 * px_size.x * Vector2(-1, 1) + 0.5 * w * Vector2(1, -1)
	
	for y in range(y_range.x, y_range.y, h):
		for x in range(x_range.x, x_range.y, w):
			add_child(wave)
			waves.append(wave)
			wave.position = Vector2(x, y) + 0.5 * Vector2(w * randf_range(-1, 1), h * randf_range(-1, 1))
			wave_origins.append(wave.position)
			wave.modulate = Color(randf_range(0, 0.1), randf_range(0.1, 0.2), 0.25, randf_range(0.2, 0.4))
			wave = wave_scn.instantiate()

func _process(_delta: float) -> void:
	var t = 0.002 * Time.get_ticks_msec()
	for i in range(len(waves)):
		waves[i].position = wave_origins[i] + 10 * ((i + 1) % 4) * Vector2(cos(t + i), sin(t + i))
