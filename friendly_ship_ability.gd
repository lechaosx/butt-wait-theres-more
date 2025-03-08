extends Node

@onready var ship_scene := preload("res://ship.tscn")
@onready var cannon_autoaim := preload("res://src/weapons/cannon_autoaim/cannon_autoaim.tscn")

var level = 0

func level_up():
	if level >= 5:
		return
	
	var ship = ship_scene.instantiate();
	ship.controller = AIShipFollowerController.new()
	ship.controller.owner_ship = get_parent()
	ship.power = 250
	ship.traction = 50
	ship.set_collision_layer_value(1, false)
	ship.set_collision_layer_value(6, true)
	ship.set_collision_mask_value(5, true)
	ship.add_child(ship.controller)
	var cannon = cannon_autoaim.instantiate()
	cannon.scale = Vector2(2, 2)
	ship.add_child(cannon)
	ship.add_to_group("frendly")
	ship.texture = load("res://assets/Ships/ship (4).png")
	ship.scale = Vector2(0.5, 0.5)
	ship.position = get_parent().position + Vector2(0, 100)
	get_tree().get_root().add_child(ship)

	level += 1
