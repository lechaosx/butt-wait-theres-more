extends Node2D

@onready var barrel = preload("res://barrel.tscn")

func _ready() -> void:
	create_barrel(Vector2(551, 469))
	create_barrel(Vector2(190, 369))
	create_barrel(Vector2(583, 144))
	SignalBus.BarrelExplodeToShip.connect(self._on_barrel_explode_to_ship)

func create_barrel(pos: Vector2) -> void:
	var parent = $"."
	var bar = barrel.instantiate()
	bar.position = pos
	#bar.BarrelExplodeToShip.connect()
	parent.add_child(bar)

func _on_barrel_explode_to_ship(barrel: Barrel) -> void:
	print_debug(barrel)
	barrel.queue_free()
