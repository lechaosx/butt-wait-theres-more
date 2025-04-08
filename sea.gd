class_name Sea extends Node

@export var abilities: Array[Ability] = []

var dead: bool = false;

signal game_ended(score: int)

var properties: PlayerProperties:
	set(value):
		$PlayerShip/HitpointBar.set_max_hitpoints(value.ship_hitpoints)
		$PlayerShip/HitpointBar.fully_heal()
		$PlayerShip.brakes = value.ship_power
		$PlayerShip.power = value.ship_power
		$PlayerShip.steering_angle = value.ship_steering_angle
		$PlayerShip.ramming_damage = value.ship_ramming_damage
		$PlayerShip/Cannon.projectile_damage = value.projectile_damage
		$PlayerShip/AutoCannonAbility.projectile_damage = value.projectile_damage

func _ready() -> void:
	$PlayerShip/FriendlyShipAbility.sea = self
	$PlayerShip/AutoCannonAbility.sea = self
	$PlayerShip/BarrelDroppingAbility.sea = self
	$PlayerShip/Cannon.sea = self

	var canons = Ability.new()
	canons.current_level = 0
	canons.max_level = 5
	canons.image = load("res://abilities/side_cannons.png")
	canons.name = "Side Cannons"
	canons.leveled.connect($PlayerShip/AutoCannonAbility.level_up)

	abilities.append(canons)

	var ships = Ability.new()
	ships.current_level = 0
	ships.max_level = 5
	ships.image = load("res://abilities/friendly_ship.png")
	ships.name = "Friendly Ships"
	ships.leveled.connect($PlayerShip/FriendlyShipAbility.level_up)

	abilities.append(ships)

	var barrels = Ability.new()
	barrels.current_level = 0
	barrels.max_level = 5
	barrels.image = load("res://abilities/barrels.png")
	barrels.name = "Exploding Barrel"
	barrels.leveled.connect($PlayerShip/BarrelDroppingAbility.level_up)

	abilities.append(barrels)

	var userCannon = Ability.new()
	userCannon.current_level = 0
	userCannon.max_level = 5
	userCannon.image = load("res://abilities/cannon_cooling.png")
	userCannon.name = "Auto Cannon Cooling System"
	userCannon.leveled.connect($PlayerShip/Cannon.level_up)

	abilities.append(userCannon)

	var piercing = Ability.new()
	piercing.current_level = 0
	piercing.max_level = 5
	piercing.image = load("res://abilities/piercing_cannon_ball.png")
	piercing.name = "Cannon Ball Piercing"
	piercing.leveled.connect($PlayerShip/Cannon.level_up_piercing)
	piercing.leveled.connect($PlayerShip/AutoCannonAbility.level_up_piercing)

	abilities.append(piercing)

func create_barrel(pos: Vector2) -> void:
	var bar = preload("res://src/barrel/barrel.tscn").instantiate()
	bar.position = pos
	add_child(bar)

func random_point_on_circle(radius: float) -> Vector2:
	var angle = randf() * TAU
	return Vector2(cos(angle), sin(angle)) * radius

func count_objects_in_radius(center: Vector2, radius: float, group_name: String) -> int:
	var count = 0
	for obj in get_tree().get_nodes_in_group(group_name):
		if obj is Node2D and obj.global_position.distance_to(center) <= radius:
			count += 1
	return count

func _on_barrel_spawn_timer_timeout() -> void:
	var screen_radius = get_viewport().get_visible_rect().size.length() / 2

	var max_radius = screen_radius * 3

	var num_floaters = count_objects_in_radius(%PlayerShip.position, max_radius, "floaters")
	if num_floaters < 10:
		var radius = randf_range(screen_radius * 1.5, max_radius)
		create_barrel(%PlayerShip.position + random_point_on_circle(radius))

func _on_man_overboard_spawn_timer_timeout() -> void:
	var man_overboard = preload("res://src/man_overboard/man_overboard.tscn").instantiate();
	man_overboard.set_collision_layer_value(1, false)
	man_overboard.set_collision_layer_value(5, true)
	man_overboard.set_collision_mask_value(4, true)

	man_overboard.position = %PlayerShip.position + random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	
	add_child(man_overboard)

func upgrade_abilities():
	var upgradable_abilities: Array[Ability] = []

	for ability in abilities:
		if ability.current_level < 5:
			upgradable_abilities.append(ability)

	upgradable_abilities.shuffle()  # Randomize the order of elements
	upgradable_abilities = upgradable_abilities.slice(0, min(2, upgradable_abilities.size()))

	if upgradable_abilities.size() > 0:
		$%AbilityCards.abilities = upgradable_abilities
		%AbilityCards.visible = true
		Engine.time_scale = 0.1

func _on_ability_cards_ability_selected(ability: Ability) -> void:
	ability.level_up()
	Engine.time_scale = 1
	%CargoCounter.count -= %CargoCounter.cargo_cap
	%CargoCounter.cargo_cap += 1

func _on_hitpoint_bar_on_death() -> void:
	if dead:
		return
		
	dead = true
	%AbilityCards.hide()
	Engine.time_scale = 1
	%KillScreen.die()
	get_tree().call_group("GameTimers", "stop")

func _on_cargo_hold_cargo_updated() -> void:
	if dead:
		return

	%CargoCounter.count = %CargoCounter.count + 1
	
	if %CargoCounter.count >= %CargoCounter.cargo_cap and not %AbilityCards.visible:
		upgrade_abilities()

func _on_kill_screen_finished() -> void:
	game_ended.emit(%SurvivorTime.score)
