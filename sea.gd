extends Node2D

@onready var barrel = preload("res://barrel.tscn")
@onready var ship_scene := preload("res://ship.tscn")

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
	
func get_random_point_outside_view() -> Vector2:
	var viewport_size = get_viewport_rect().size
	
	var min_distance = sqrt(pow(viewport_size.x / 2, 2) + pow(viewport_size.y / 2, 2)) * 1.5 
	var angle = randf() * TAU
	
	return get_viewport_rect().get_center() + Vector2(cos(angle), sin(angle)) * min_distance

func _on_barrel_explode_to_ship(barrel: Barrel) -> void:
	print_debug(barrel)
	barrel.queue_free()


func _on_enemy_spawn_timer_timeout() -> void:
	var ship = ship_scene.instantiate();
	ship.controller = AIShipController.new()
	ship.controller.target = %PlayerShip
	ship.add_child(ship.controller)
	ship.position = get_random_point_outside_view()
	ship.texture = load("res://assets/Ships/ship (2).png")
	add_child(ship)
