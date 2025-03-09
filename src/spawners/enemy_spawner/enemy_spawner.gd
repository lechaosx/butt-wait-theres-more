extends Node2D

@onready var ship_scene := preload("res://ship.tscn")
@onready var hitpoint_scene := preload("res://src/hitpoints/hitpoint_bar.tscn")
@onready var cargo_scene := preload("res://cargo.tscn")

@onready var cannon_automatic_scene := preload("res://src/weapons/cannon_automatic/cannon_automatic.tscn")

@export var difficulty_score : float = 10.0 
var base_hp = 5

func _process(delta: float) -> void:
	difficulty_score += delta

func random_point_on_circle(radius: float) -> Vector2:
	var angle = randf() * TAU
	return Vector2(cos(angle), sin(angle)) * radius

func _on_enemy_death(enemy:Node) -> void:
	var cargo = cargo_scene.instantiate()
	cargo.position = enemy.position
	get_tree().root.call_deferred("add_child", cargo)
	enemy.queue_free()

func spawn_enemy_ship():
	var ship = ship_scene.instantiate();
	ship.controller = AIShipController.new()
	ship.controller.target = %PlayerShip
	ship.add_child(ship.controller)

	ship.set_collision_layer_value(1, false)
	ship.set_collision_layer_value(5, true)
	ship.is_frendly = false;
	ship.add_to_group("enemies")

	ship.position = %PlayerShip.position + random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	ship.texture = load("res://assets/Ships/ship (2).png")
	return ship

func add_hp(ship, hp):
	var HP = hitpoint_scene.instantiate()
	HP.on_death.connect(_on_enemy_death)
	HP.set_max_hitpoints(5)
	ship.add_child(HP)

func spawn_ramming_enemy(hp):
	var ship = spawn_enemy_ship()
	add_hp(ship, hp)
	get_tree().root.add_child(ship)
	
func spawn_gun_enemy(hp):
	var ship = spawn_enemy_ship()
	add_hp(ship, hp)
	var cannon = cannon_automatic_scene.instantiate()
	ship.add_child(cannon)
	cannon.set_z_index(2)
	get_tree().root.add_child(ship)

func _on_timer_timeout() -> void:
	var rand = randf()
	
	if rand < 0.01 * difficulty_score:
		var hp = base_hp * 2 + clamp(round(difficulty_score / 50), 0, 10)
		spawn_gun_enemy(hp)
	else:
		var hp = base_hp + clamp(round(difficulty_score / 50), 0, 10)
		spawn_ramming_enemy(hp)
