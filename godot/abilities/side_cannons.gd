class_name SideCannons extends Node2D

@export var world: Node
@export var parent: CharacterBody2D

@export var projectile_damage: int = 1

var _pairs: int = 0
var _piercing: int = 0

func add_pair() -> void:
	var pos_x := position.x + 30 - (_pairs * 15)
	
	const canon_scene := preload("auto_cannon.tscn")
	
	var left_cannon := canon_scene.instantiate()
	var right_cannon := canon_scene.instantiate()
	
	left_cannon.interval = 2.0;
	right_cannon.interval = 2.0;
	
	left_cannon.set_z_index(0)
	right_cannon.set_z_index(0)
	
	left_cannon.position.y = 15
	right_cannon.position.y = -15
	
	left_cannon.position.x = pos_x
	right_cannon.position.x = pos_x
	
	left_cannon.rotation = deg_to_rad(90)
	right_cannon.rotation = deg_to_rad(-90)
	
	left_cannon.piercing = _piercing
	right_cannon.piercing = _piercing
	
	left_cannon.world = world
	right_cannon.world = world
	
	left_cannon.parent = parent
	right_cannon.parent = parent
	
	left_cannon.projectile_damage = projectile_damage
	right_cannon.projectile_damage = projectile_damage
	
	add_child(left_cannon)
	add_child(right_cannon)

	_pairs += 1

func level_up_piercing() -> void:
	_piercing += 1
	
	for cannon in get_children():
		cannon.piercing = _piercing
