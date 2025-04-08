extends Node2D

@onready var canon_scene = preload("cannon.tscn")

var projectile_damage
var level = 0
var piercing = 0
var sea

func level_up():
	if level >= 5:
		return
	
	var pos_x = position.x + 30 - (level * 15)
	
	var left_cannon = canon_scene.instantiate()
	var right_cannon = canon_scene.instantiate()
	
	left_cannon.set_z_index(0)
	right_cannon.set_z_index(0)
	
	left_cannon.position.y = 15
	right_cannon.position.y = -15
	
	left_cannon.autofire = true
	right_cannon.autofire = true

	left_cannon.position.x = pos_x
	right_cannon.position.x = pos_x
	
	left_cannon.rotation = deg_to_rad(90)
	right_cannon.rotation = deg_to_rad(-90)
	
	left_cannon.piercing = piercing
	right_cannon.piercing = piercing
	
	left_cannon.sea = sea
	right_cannon.sea = sea
	
	left_cannon.projectile_damage = projectile_damage
	right_cannon.projectile_damage = projectile_damage
	
	get_parent().add_child(left_cannon)
	get_parent().add_child(right_cannon)

	level += 1

func level_up_piercing():
	if piercing >= 5:
		return
		
	piercing += 1
	
	for child in get_parent().get_children():
		if child is Cannon:
			child.piercing = piercing
