class_name FriendlyShipSpawner extends Node

@export var sea: Sea

func spawn() -> void:
	var ship := preload("res://ship.tscn").instantiate();
	ship.controller = AIShipFollowerController.new()
	ship.controller.owner_ship = get_parent()
	ship.power = 250
	ship.traction = 50
	ship.add_child(ship.controller)
	
	var cannon := preload("res://cannon.tscn").instantiate()
	cannon.position.x = 40
	cannon.world = sea
	cannon.parent = ship
	
	var controller := preload("res://auto_aim_cannon_controller.tscn").instantiate()
	controller.cannon = cannon
	cannon.add_child(controller)
	
	var timer := Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	timer.timeout.connect(cannon.fire)
	cannon.add_child(timer)
	
	ship.add_child(cannon)
	
	ship.add_to_group("friendly")
	ship.get_node("AnimatedSprite2D").animation = "green"
	ship.scale = Vector2(0.5, 0.5)
	ship.position = get_parent().position + Vector2(0, 100)
	
	sea.add_child(ship)
