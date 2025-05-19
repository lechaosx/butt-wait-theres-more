class_name FriendlyShipSpawner extends Node

@export var sea: Sea

func spawn() -> void:
	var ship := preload("res://ship.tscn").instantiate();
	ship.controller = AIShipFollowerController.new()
	ship.controller.owner_ship = get_parent()
	ship.power = 250
	ship.traction = 50
	ship.add_child(ship.controller)
	
	var cannon := preload("auto_cannon.tscn").instantiate()
	cannon.interval = 2
	cannon.position.x = 40
	cannon.add_child(AutoAimCannonController.new())
	ship.add_child(cannon)
	cannon.world = sea
	cannon.parent = ship
	
	ship.add_to_group("friendly")
	ship.get_node("AnimatedSprite2D").animation = "green"
	ship.scale = Vector2(0.5, 0.5)
	ship.position = get_parent().position + Vector2(0, 100)
	
	sea.add_child(ship)
