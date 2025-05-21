extends Node

@export var world: Node
@export var difficulty_score : float = 10.0 
@export var base_hp: int = 5

const cannon_scene := preload("res://cannon.tscn")
const ship_scene := preload("res://enemy_ship.tscn")

func _process(delta: float) -> void:
	difficulty_score += delta

func _random_point_on_circle(radius: float) -> Vector2:
	var angle := randf() * TAU
	return Vector2(cos(angle), sin(angle)) * radius

func _spawn_ramming_enemy(health: int) -> void:
	var ship := ship_scene.instantiate();
	ship.target = %PlayerShip
	ship.position = %PlayerShip.position + _random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	ship.max_health = health
	ship.health = health
	ship.cargo = 1
	world.add_child(ship)
	
func _spawn_gun_enemy(health: int) -> void:
	var ship := ship_scene.instantiate();
	ship.target = %PlayerShip
	ship.position = %PlayerShip.position + _random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	ship.max_health = health
	ship.health = health
	ship.cargo = 2
	
	var timer := Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	ship.add_child(timer)
	
	var cannon := cannon_scene.instantiate()
	cannon.position.x = 42
	cannon.set_z_index(2)
	cannon.world = world
	cannon.parent = ship
	ship.add_child(cannon)
	
	timer.timeout.connect(cannon.fire)
	
	if randf() < 0.001 * difficulty_score:
		ship.cargo = 3
		
		for side: int in [-1, 1]:
			var side_cannon := cannon_scene.instantiate()
			side_cannon.position.x = 30
			side_cannon.position.y = 15 * side
			side_cannon.rotation = deg_to_rad(45 * side)
			side_cannon.set_z_index(2)
			side_cannon.world = world
			side_cannon.parent = ship
			timer.timeout.connect(side_cannon.fire)
			ship.add_child(side_cannon)
	
	world.add_child(ship)

func _spawn_boss_enemy(health: int) -> void:
	var ship := ship_scene.instantiate();
	ship.target = %PlayerShip
	ship.position = %PlayerShip.position + _random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	ship.max_health = health
	ship.health = health
	ship.global_scale = Vector2(2, 2)
	ship.cargo = 4
	
	var timer := Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	ship.add_child(timer)
	
	for n in 8:
		var cannon := cannon_scene.instantiate()
		cannon.scale = Vector2(0.5, 0.5)
		cannon.position.x = 21
		cannon.position.y = (4 - n) * 6
		cannon.set_z_index(2)
		cannon.world = world
		cannon.parent = ship
		
		timer.timeout.connect(cannon.fire)
		
		ship.add_child(cannon)
		
	add_child(ship)

func _spawn_boss_enemy_2(health: int) -> void:
	var ship := ship_scene.instantiate();
	ship.target = %PlayerShip
	ship.position = %PlayerShip.position + _random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	ship.max_health = health
	ship.health = health
	ship.global_scale = Vector2(3, 3)
	ship.cargo = 5
	
	var timer := Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	ship.add_child(timer)
	
	for n in 10:
		var cannon := cannon_scene.instantiate()
		cannon.scale = Vector2(0.3, 0.3)
		cannon.position.x = 13
		cannon.position.y = (5 - n) * 4
		cannon.default_cannon_cooldown_time = 1
		cannon.ball_speed = cannon.ball_speed * 2
		cannon.set_z_index(2)
		cannon.world = world
		cannon.parent = ship
		
		timer.timeout.connect(cannon.fire)
		
		ship.add_child(cannon)
		
	add_child(ship)


func _on_timer_timeout() -> void:
	$Timer.wait_time = clamp($Timer.wait_time - 0.01, 2, 6)
	
	if randf() < 0.01 * difficulty_score:
		var health: int = base_hp * 2 + clamp(round(difficulty_score / 50), 0, 10)
		_spawn_gun_enemy(health)
	else:
		var health: int = base_hp + clamp(round(difficulty_score / 50), 0, 10)
		_spawn_ramming_enemy(health)


func _on_boss_timer_timeout() -> void:
	if difficulty_score >= 300:
		for n in range(round(difficulty_score / 400)):
			_spawn_boss_enemy_2(100)
	else:
		for n in range(round(difficulty_score / 60)):
			_spawn_boss_enemy(60)
