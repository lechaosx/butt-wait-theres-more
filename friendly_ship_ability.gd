extends Node

@onready var ship_scene := preload("res://ship.tscn")
@onready var cannon_autoaim := preload("res://src/weapons/cannon/cannon.tscn")
@onready var cannon_autoaim_controller := preload("res://auto_aim_cannon_controller.tscn")

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
	cannon.position.x = 40
	ship.add_child(cannon)
	var autoaim_controller = cannon_autoaim_controller.instantiate()
	cannon.add_child(autoaim_controller)
	ship.add_to_group("friendly")
	ship.type = Ship.Type.Friendly
	ship.scale = Vector2(0.5, 0.5)
	ship.position = get_parent().position + Vector2(0, 100)
	get_tree().get_root().add_child(ship)

	level += 1
