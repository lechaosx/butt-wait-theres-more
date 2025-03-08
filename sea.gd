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
	
func get_random_point_on_circle(radius: float) -> Vector2:
	var angle = randf() * TAU
	return get_viewport_rect().get_center() + Vector2(cos(angle), sin(angle)) * radius

func count_objects_in_radius(center: Vector2, radius: float, group_name: String) -> int:
	var count = 0
	for obj in get_tree().get_nodes_in_group(group_name):
		if obj is Node2D and obj.global_position.distance_to(center) <= radius:
			count += 1
	return count

func _on_barrel_explode_to_ship(barrel: Barrel) -> void:
	print_debug(barrel)
	barrel.queue_free()


func _on_enemy_spawn_timer_timeout() -> void:
	var ship = ship_scene.instantiate();
	ship.controller = AIShipController.new()
	ship.controller.target = %PlayerShip
	ship.add_child(ship.controller)
	
	ship.position = %PlayerShip.position + get_random_point_on_circle(get_viewport_rect().size.length() / 2)
	
	ship.texture = load("res://assets/Ships/ship (2).png")
	#add_child(ship)


func _on_barrel_spawn_timer_timeout() -> void:
	var screen_radius = get_viewport_rect().size.length() / 2
	var num_floaters = count_objects_in_radius(%PlayerShip.position, screen_radius * 3, "floaters") 
	if num_floaters < 10:
		var radius = randf_range(screen_radius * 2, screen_radius * 3)
		create_barrel(%PlayerShip.position + get_random_point_on_circle(radius))
