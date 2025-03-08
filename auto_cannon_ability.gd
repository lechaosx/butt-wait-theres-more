extends Node2D

@onready var canon_scene = preload("res://src/weapons/cannon_automatic/cannon_automatic.tscn")

var level = 0

func level_up():
	if level >= 5:
		return
	
	var pos_x = position.x + 30 - (level * 15)
	
	var left_cannon = canon_scene.instantiate()
	var right_cannon = canon_scene.instantiate()

	left_cannon.position.x = pos_x
	right_cannon.position.x = pos_x
	
	left_cannon.rotation = deg_to_rad(90)
	right_cannon.rotation = deg_to_rad(-90)
	
	add_child(left_cannon)
	add_child(right_cannon)

	level += 1
