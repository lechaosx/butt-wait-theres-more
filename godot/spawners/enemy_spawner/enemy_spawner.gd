extends Node2D

@export var world: Node
@export var difficulty_score : float = 10.0 
@export var base_hp: int = 5

const cannon_scene := preload("res://cannon.tscn")

func _process(delta: float) -> void:
	difficulty_score += delta

func random_point_on_circle(radius: float) -> Vector2:
	var angle := randf() * TAU
	return Vector2(cos(angle), sin(angle)) * radius

func _on_enemy_death(enemy:Node) -> void:
	var cargo := preload("res://cargo.tscn").instantiate()
	cargo.position = enemy.position
	call_deferred("add_child", cargo)
	enemy.queue_free()

func spawn_enemy_ship() -> Ship:
	var ship := preload("res://ship.tscn").instantiate();
	ship.controller = AIShipController.new()
	ship.controller.target = %PlayerShip
	ship.add_child(ship.controller)

	ship.add_to_group("enemies")

	ship.position = %PlayerShip.position + random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	ship.get_node("AnimatedSprite2D").animation = "gray"
	return ship

func add_hp(ship: Ship, health: int) -> void:
	ship.health_updated.connect(func() -> void: 
		if ship.health <= 0: 
			_on_enemy_death(ship)
	)
	ship.max_health = health
	ship.health = health

func spawn_ramming_enemy(health: int) -> void:
	var ship := spawn_enemy_ship()
	add_hp(ship, health)
	add_child(ship)
	
func spawn_gun_enemy(health: int) -> void:
	var ship := spawn_enemy_ship()
	add_hp(ship, health)
	var cannon := cannon_scene.instantiate()
	cannon.position.x = 42
	cannon.set_z_index(2)
	cannon.world = world
	cannon.parent = ship
	
	var timer := Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	timer.timeout.connect(cannon.fire)
	ship.add_child(timer)
	
	ship.add_child(cannon)
	
	if randf() < 0.001 * difficulty_score:
		var left_cannon := cannon_scene.instantiate()
		var right_cannon := cannon_scene.instantiate()
		left_cannon.position.x = 30
		left_cannon.position.y = 15
		right_cannon.position.x = 30
		right_cannon.position.y = -15
		left_cannon.rotation = deg_to_rad(45)
		right_cannon.rotation = deg_to_rad(-45)
		left_cannon.set_z_index(2)
		right_cannon.set_z_index(2)
		left_cannon.world = world
		right_cannon.world = world
		left_cannon.parent = ship
		right_cannon.parent = ship
		
		timer.timeout.connect(left_cannon.fire)
		timer.timeout.connect(right_cannon.fire)
		
		ship.add_child(left_cannon)
		ship.add_child(right_cannon)
	
	add_child(ship)

func scale_ship(ship: Ship, ship_scale: float) -> void:
	var scaling_components := [
		ship.get_node("AnimatedSprite2D"),
		ship.get_node("CollisionShape2D"),
		ship.get_node("CollisionShape2D2"),
		ship.get_node("RamArea/CollisionShape2D2"),
	]
	
	for scaling_componnent: Node2D in scaling_components:
		if not scaling_componnent:
			continue
			
		scaling_componnent.transform *= ship_scale # this should multiply scale and position
	

func spawn_boss_enemy(health: int) -> void:
	var ship := spawn_enemy_ship()
	add_hp(ship, health)
	scale_ship(ship,2)
	
	for n in 8:
		var cannon := cannon_scene.instantiate()
		cannon.position.x = 42
		cannon.position.y = (4 - n) * 12.5
		cannon.set_z_index(2)
		cannon.world = world
		cannon.parent = ship
		
		var timer := Timer.new()
		timer.wait_time = 2
		timer.autostart = true
		timer.timeout.connect(cannon.fire)
		cannon.add_child(timer)
		
		ship.add_child(cannon)
		
	add_child(ship)

func spawn_boss_enemy_2(health: int) -> void:
	var ship := spawn_enemy_ship()
	add_hp(ship, health)
	
	scale_ship(ship, 3)
	
	for n in 10:
		var cannon := cannon_scene.instantiate()
		cannon.position.x = 42
		cannon.position.y = (5 - n) * 12.5
		cannon.default_cannon_cooldown_time = 1
		cannon.ball_speed = cannon.ball_speed * 2
		cannon.set_z_index(2)
		cannon.world = world
		cannon.parent = ship
		
		var timer := Timer.new()
		timer.wait_time = 2
		timer.autostart = true
		timer.timeout.connect(cannon.fire)
		cannon.add_child(timer)
		
		ship.add_child(cannon)
		
	add_child(ship)


func _on_timer_timeout() -> void:
	$Timer.wait_time = clamp($Timer.wait_time - 0.01, 2, 6)
	
	if randf() < 0.01 * difficulty_score:
		var health: int = base_hp * 2 + clamp(round(difficulty_score / 50), 0, 10)
		spawn_gun_enemy(health)
	else:
		var health: int = base_hp + clamp(round(difficulty_score / 50), 0, 10)
		spawn_ramming_enemy(health)


func _on_boss_timer_timeout() -> void:
	if difficulty_score >= 300:
		for n in range(round(difficulty_score / 400)):
			spawn_boss_enemy_2(100)
	else:
		for n in range(round(difficulty_score / 60)):
			spawn_boss_enemy(60)
