@tool class_name Sea extends Node

signal game_ended(score: int)

@export var hitpoints: int:
	set(value):
		hitpoints = value
		if not is_node_ready(): await ready
		$PlayerShip.max_health = hitpoints
		$PlayerShip.health = hitpoints
		
@export var acceleration: int:
	set(value):
		acceleration = value
		if not is_node_ready(): await ready
		$PlayerShip.power = acceleration

@export var steering: int:
	set(value):
		steering = value
		if not is_node_ready(): await ready
		$PlayerShip.steering = steering
		
@export var ram_damage: int:
	set(value):
		ram_damage = value
		if not is_node_ready(): await ready
		$PlayerShip.ramming_damage = ram_damage
		
@export var cannon_damage: int:
	set(value):
		cannon_damage = value
		if not is_node_ready(): await ready
		%PlayerShip.projectile_damage = cannon_damage
		
func _random_point_on_circle(radius: float) -> Vector2:
	var angle := randf() * TAU
	return Vector2(cos(angle), sin(angle)) * radius

func _on_barrel_spawn_timer_timeout() -> void:
	var screen_radius := get_viewport().get_visible_rect().size.length() / 2

	var max_radius := screen_radius * 3
	
	var count: int = 0
	for obj in get_tree().get_nodes_in_group("floaters"):
		if obj is Node2D and obj.global_position.distance_to(%PlayerShip.position) <= max_radius:
			count += 1

	if count < 10:
		var barrel := preload("res://barrel/barrel.tscn").instantiate()
		barrel.position = %PlayerShip.position + _random_point_on_circle(randf_range(screen_radius * 1.5, max_radius))
		add_child(barrel)

func _on_man_overboard_spawn_timer_timeout() -> void:
	var man_overboard := preload("res://man_overboard/man_overboard.tscn").instantiate();
	
	man_overboard.position = %PlayerShip.position + _random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	
	add_child(man_overboard)

func _on_cooling_leveled_up() -> void:
	%PlayerShip.cannon_cooldown = 2.0 - (2.0 * $Abilities/Cooling.level() / 6.0)

func _on_piercing_leveled_up() -> void:
	%PlayerShip.projectile_piercing += 1

func _on_side_cannons_leveled_up() -> void:
	%PlayerShip.side_cannon_pairs += 1

func _on_friendly_ships_leveled_up() -> void:
	var ship := preload("res://ships/friendly_ship.tscn").instantiate()
	
	ship.parent = %PlayerShip
	ship.world = self
	ship.global_position = %PlayerShip.global_position + _random_point_on_circle(100)
	
	add_child(ship)

func _on_barrels_leveled_up() -> void:
	%PlayerShip.barrel_cooldown = 5.0 / $Abilities/Barrels.level()

func _on_player_ship_health_updated() -> void:
	%PlayerHitpoints.set_hitpoints(%PlayerShip.health)
	
	if %PlayerShip.health <= 0:
		%AbilityCards.hide()
		await %KillScreen.die()
		game_ended.emit(%SurvivorTime.score)

func _on_player_ship_max_health_updated() -> void:
	%PlayerHitpoints.set_max_hitpoints(%PlayerShip.max_health)

func _on_player_ship_cargo_updated() -> void:
	%CargoCounter.count = %PlayerShip.cargo
	
	if not get_tree().paused and %PlayerShip.cargo >= %CargoCounter.cargo_cap:
		var upgradable_abilities: Array[Ability] = []

		for ability in %Abilities.get_children():
			if ability.level() < ability.info.max_level:
				upgradable_abilities.append(ability)

		upgradable_abilities.shuffle()  # Randomize the order of elements
		upgradable_abilities = upgradable_abilities.slice(0, min(2, upgradable_abilities.size()))

		if upgradable_abilities.size() > 0:
			get_tree().paused = true
			var ability: Ability = await %AbilityCards.select_ability(upgradable_abilities)
			get_tree().paused = false
			
			ability.level_up()
		
			%CargoCounter.cargo_cap += 1
			%PlayerShip.cargo -= %CargoCounter.cargo_cap - 1
			
# I made this formula up. It should soften turns when the analog stick is less than PI / 8 radians from the current sthip direction
static func _soft_turn_direction(ship_direction: Vector2, desired_direction: Vector2) -> float:
	return sin(clamp(ship_direction.angle_to(desired_direction), -PI / 8, PI / 8) * 4)

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return;
		
	var keyboard_acceleration := Input.get_action_strength("accelerate")
	var keyboard_steer := Input.get_axis("steer_left", "steer_right")
	
	var sail_intent: Vector2 = Input.get_vector("sail_left", "sail_right", "sail_up", "sail_down") + %VirtualJoystick.direction
	
	var	analog_steer := _soft_turn_direction(%PlayerShip.global_transform.x, sail_intent) if sail_intent != Vector2.ZERO else 0.0
	
	%PlayerShip.acceleration_intent = clamp(sail_intent.length() + keyboard_acceleration, 0.0, 1.0)
	%PlayerShip.steer_intent = clamp(analog_steer + keyboard_steer, -1.0, 1.0)
	
func _ready() -> void:
	%PlayerHitpoints.set_hitpoints(%PlayerShip.health)
	%PlayerHitpoints.set_max_hitpoints(%PlayerShip.max_health)
