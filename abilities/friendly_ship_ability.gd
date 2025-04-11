extends Node

@export var sea: Sea

var level: int = 0

func level_up() -> void:
	if level >= 5:
		return
	
	var ship := preload("res://ship.tscn").instantiate();
	ship.controller = AIShipFollowerController.new()
	ship.controller.owner_ship = get_parent()
	ship.power = 250
	ship.traction = 50
	ship.set_collision_layer_value(1, false)
	ship.set_collision_layer_value(6, true)
	ship.set_collision_mask_value(5, true)
	ship.add_child(ship.controller)
	var cannon := preload("cannon.tscn").instantiate()
	cannon.position.x = 40
	ship.add_child(cannon)
	var autoaim_controller := preload("auto_aim_cannon_controller.tscn").instantiate()
	cannon.add_child(autoaim_controller)
	ship.add_to_group("friendly")
	ship.type = Ship.Type.Friendly
	ship.scale = Vector2(0.5, 0.5)
	ship.position = get_parent().position + Vector2(0, 100)
	sea.add_child(ship)

	level += 1
