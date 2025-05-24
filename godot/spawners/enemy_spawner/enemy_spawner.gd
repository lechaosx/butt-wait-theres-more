extends Node

@export var world: Node
@export var difficulty_score : float = 10.0 
@export var base_hp: int = 5

func _process(delta: float) -> void:
	difficulty_score += delta

func _random_point_on_circle(radius: float) -> Vector2:
	var angle := randf() * TAU
	return Vector2(cos(angle), sin(angle)) * radius

func _on_timer_timeout() -> void:
	$Timer.wait_time = clamp($Timer.wait_time - 0.01, 2, 6)
	
	var ship := preload("res://ships/enemy_ship.tscn").instantiate();
	ship.target = %PlayerShip
	ship.position = %PlayerShip.position + _random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	ship.world = world
	ship.max_health = base_hp + clamp(round(difficulty_score / 50), 0, 10)
	ship.health = ship.max_health
	
	if randf() < 0.01 * difficulty_score:
		ship.max_health *= 2
		ship.health = ship.max_health
		ship.central_cannon = true
		ship.cargo = 2
		
		if randf() < 0.001 * difficulty_score:
			ship.side_cannons = true
			ship.cargo = 3
		
	world.add_child(ship)

func _on_boss_timer_timeout() -> void:
	if difficulty_score >= 300:
		for n in range(round(difficulty_score / 400)):
			var ship := preload("res://ships/large_boss_ship.tscn").instantiate();
			ship.world = world
			ship.target = %PlayerShip
			ship.position = %PlayerShip.position + _random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
			world.add_child(ship)
	else:
		for n in range(round(difficulty_score / 60)):
			var ship := preload("res://ships/small_boss_ship.tscn").instantiate();
			ship.world = world
			ship.target = %PlayerShip
			ship.position = %PlayerShip.position + _random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
			world.add_child(ship)
