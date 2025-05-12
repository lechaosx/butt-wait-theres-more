extends Node2D

@export var sea: Sea
@export var difficulty_score : float = 10.0 
@export var base_hp: int = 5

const cannon_scene := preload("res://abilities/auto_cannon.tscn")

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

func add_hp(ship: Ship, hitpoints: int) -> void:
	var HP := preload("res://hitpoints/health_component.tscn").instantiate()
	HP.died.connect(_on_enemy_death.bind(ship))
	HP.max_hitpoints = hitpoints
	HP.hitpoints = hitpoints
	ship.add_child(HP)

func spawn_ramming_enemy(hitpoints: int) -> void:
	var ship := spawn_enemy_ship()
	add_hp(ship, hitpoints)
	add_child(ship)
	
func spawn_gun_enemy(hitpoints: int) -> void:
	var ship := spawn_enemy_ship()
	add_hp(ship, hitpoints)
	var cannon := cannon_scene.instantiate()
	cannon.interval = 2
	cannon.position.x = 42
	cannon.set_z_index(2)
	cannon.sea = sea
	cannon.body = ship
	ship.add_child(cannon)
	
	if randf() < 0.001 * difficulty_score:
		var left_cannon := cannon_scene.instantiate()
		var right_cannon := cannon_scene.instantiate()
		left_cannon.interval = 2
		right_cannon.interval = 2
		left_cannon.position.x = 30
		left_cannon.position.y = 15
		right_cannon.position.x = 30
		right_cannon.position.y = -15
		left_cannon.rotation = deg_to_rad(45)
		right_cannon.rotation = deg_to_rad(-45)
		left_cannon.set_z_index(2)
		right_cannon.set_z_index(2)
		left_cannon.sea = sea
		right_cannon.sea = sea
		left_cannon.body = ship
		right_cannon.body = ship
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
	

func spawn_boss_enemy(hitpoints: int) -> void:
	var ship := spawn_enemy_ship()
	add_hp(ship, hitpoints)
	scale_ship(ship,2)
	
	for n in 8:
		var cannon := cannon_scene.instantiate()
		cannon.interval = 2
		cannon.position.x = 42
		cannon.position.y = (4 - n) * 12.5
		cannon.set_z_index(2)
		cannon.sea = sea
		cannon.body = ship
		ship.add_child(cannon)
		
	add_child(ship)

func spawn_boss_enemy_2(hitpoints: int) -> void:
	var ship := spawn_enemy_ship()
	add_hp(ship, hitpoints)
	
	scale_ship(ship, 3)
	
	for n in 10:
		var cannon := cannon_scene.instantiate()
		cannon.interval = 2
		cannon.position.x = 42
		cannon.position.y = (5 - n) * 12.5
		cannon.default_cannon_cooldown_time = 1
		cannon.ball_speed = cannon.ball_speed * 2
		cannon.set_z_index(2)
		cannon.sea = sea
		cannon.body = ship
		ship.add_child(cannon)
		
	add_child(ship)


func _on_timer_timeout() -> void:
	$Timer.wait_time = clamp($Timer.wait_time - 0.01, 2, 6)
	
	if randf() < 0.01 * difficulty_score:
		var hitpoints: int = base_hp * 2 + clamp(round(difficulty_score / 50), 0, 10)
		spawn_gun_enemy(hitpoints)
	else:
		var hitpoints: int = base_hp + clamp(round(difficulty_score / 50), 0, 10)
		spawn_ramming_enemy(hitpoints)


func _on_boss_timer_timeout() -> void:
	if difficulty_score >= 300:
		for n in range(round(difficulty_score / 400)):
			spawn_boss_enemy_2(100)
	else:
		for n in range(round(difficulty_score / 60)):
			spawn_boss_enemy(60)
