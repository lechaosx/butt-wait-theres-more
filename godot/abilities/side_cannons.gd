@tool class_name SideCannons extends Node2D

@export var world: Node
@export var parent: CharacterBody2D

@export var projectile_damage: int = 1:
	set(value):
		projectile_damage = value
		if not is_node_ready(): await ready
		for cannon in get_children():
			cannon.projectile_damage = value
			
@export var projectile_piercing: int = 0:
	set(value):
		projectile_piercing = value
		if not is_node_ready(): await ready
		for cannon in get_children():
			cannon.projectile_piercing = value
			
@export_range(0, 5) var pairs: int = 0:
	set(value):
		if not is_node_ready(): await ready
		while pairs < value:
			_add_pair()
			pairs += 1
			
		while pairs > value:
			_remove_pair()
			pairs -= 1
			
func _add_pair() -> void:
	var pos_x := position.x + 30 - (pairs * 15)
	
	for side: int in [1, -1]:
		var cannon := preload("res://cannon.tscn").instantiate()
		cannon.set_z_index(-1)
		cannon.position.y = 15 * side
		cannon.position.x = pos_x
		cannon.rotation = deg_to_rad(90 * side)
		cannon.projectile_piercing = projectile_piercing
		cannon.world = world
		cannon.parent = parent
		cannon.projectile_damage = projectile_damage
		add_child(cannon)
		
func _remove_pair() -> void:
	var children := get_children()
	var right := children[-1]
	var left := children[-2]
	left.queue_free()
	right.queue_free()
	
func fire() -> void:
	for cannon in get_children():
		cannon.fire()
