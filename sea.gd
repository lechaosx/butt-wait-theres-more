extends Node

@onready var barrel = preload("res://barrel.tscn")
@onready var ship_scene := preload("res://ship.tscn")
@onready var hitpoint_scene := preload("res://src/hitpoints/hitpoint_bar.tscn")

@export var abilities: Array[Ability] = []

func _ready() -> void:
	SignalBus.BarrelExplodeToShip.connect(self._on_barrel_explode_to_ship)
	
	var canons = Ability.new()
	canons.current_level = 0
	canons.max_level = 5
	canons.image = load("res://assets/Ship parts/cannon.png")
	canons.name = "Automatic Cannon"
	canons.leveled.connect($PlayerShip/AutoCannonAbility.level_up)
	
	abilities.append(canons)
	
	var ship = ship_scene.instantiate();
	ship.controller = AIShipFollowerController.new()
	ship.controller.owner_ship = %PlayerShip
	ship.power = 250
	ship.traction = 50
	ship.set_collision_layer_value(1, false)
	ship.set_collision_layer_value(6, true)
	ship.set_collision_mask_value(5, true)
	ship.add_child(ship.controller)
	ship.texture = load("res://assets/Ships/ship (4).png")
	ship.scale = Vector2(0.5, 0.5)
	ship.position = Vector2(-50,-50)
	add_child(ship)
	

func create_barrel(pos: Vector2) -> void:
	var parent = $"."
	var bar = barrel.instantiate()
	bar.position = pos
	
	var HP = hitpoint_scene.instantiate()
	HP.on_death.connect(self._on_enemy_death)
	HP.set_max_hitpoints(5)
	
	bar.add_child(HP)
	
	parent.add_child(bar)
	
func random_point_on_circle(radius: float) -> Vector2:
	var angle = randf() * TAU
	return Vector2(cos(angle), sin(angle)) * radius

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
	
	ship.set_collision_layer_value(1, false)
	ship.set_collision_layer_value(5, true)
	ship.set_collision_mask_value(4, true)
	ship.is_frendly = false;
	ship.add_to_group("enemies")
	
	ship.position = %PlayerShip.position + random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	ship.texture = load("res://assets/Ships/ship (2).png")
	
	var HP = hitpoint_scene.instantiate()
	HP.on_death.connect(self._on_enemy_death)
	HP.set_max_hitpoints(5)
	
	ship.add_child(HP)
	
	add_child(ship)


func _on_barrel_spawn_timer_timeout() -> void:
	var screen_radius = get_viewport().get_visible_rect().size.length() / 2
	
	var max_radius = screen_radius * 3
	
	var num_floaters = count_objects_in_radius(%PlayerShip.position, max_radius, "floaters") 
	if num_floaters < 10:
		var radius = randf_range(screen_radius * 1.5, max_radius)
		create_barrel(%PlayerShip.position + random_point_on_circle(radius))
	
func _on_enemy_death(enemy:CharacterBody2D) -> void:
	enemy.queue_free()
	upgrade_abilities()
	
func upgrade_abilities():
	$%AbilityCards.abilities = abilities
	%AbilityCards.visible = true
	Engine.time_scale = 0.1
	
func _on_ability_cards_ability_selected(ability: Ability) -> void:
	ability.level_up()
	Engine.time_scale = 1


func _on_hitpoint_bar_on_death(parent: Node) -> void:
	%KillScreen.die()
