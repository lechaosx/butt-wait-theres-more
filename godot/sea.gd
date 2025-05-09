class_name Sea extends Node

signal game_ended(score: int)

@export var hitpoints: int:
	set(value):
		hitpoints = value

		if not is_node_ready(): await ready

		$PlayerShip/HealthComponent.max_hitpoints = hitpoints
		$PlayerShip/HealthComponent.hitpoints = hitpoints
		
@export var acceleration: int:
	set(value):
		acceleration = value

		if not is_node_ready(): await ready

		$PlayerShip.brakes = acceleration
		$PlayerShip.power = acceleration

@export var steering: int:
	set(value):
		steering = value

		if not is_node_ready(): await ready

		$PlayerShip.steering_angle = steering
		
@export var ram_damage: int:
	set(value):
		ram_damage = value

		if not is_node_ready(): await ready

		$PlayerShip.ramming_damage = ram_damage
		
@export var cannon_damage: int:
	set(value):
		cannon_damage = value

		if not is_node_ready(): await ready

		%AutoCannon.projectile_damage = cannon_damage
		%SideCannons.projectile_damage = cannon_damage

var _dead: bool = false;

func create_barrel(position: Vector2) -> void:
	var barrel := preload("res://barrel/barrel.tscn").instantiate()
	barrel.position = position
	add_child(barrel)

func random_point_on_circle(radius: float) -> Vector2:
	var angle := randf() * TAU
	return Vector2(cos(angle), sin(angle)) * radius

func count_objects_in_radius(center: Vector2, radius: float, group_name: String) -> int:
	var count: int = 0
	for obj in get_tree().get_nodes_in_group(group_name):
		if obj is Node2D and obj.global_position.distance_to(center) <= radius:
			count += 1
	return count

func _on_barrel_spawn_timer_timeout() -> void:
	var screen_radius := get_viewport().get_visible_rect().size.length() / 2

	var max_radius := screen_radius * 3

	var num_floaters := count_objects_in_radius(%PlayerShip.position, max_radius, "floaters")
	if num_floaters < 10:
		var radius := randf_range(screen_radius * 1.5, max_radius)
		create_barrel(%PlayerShip.position + random_point_on_circle(radius))

func _on_man_overboard_spawn_timer_timeout() -> void:
	var man_overboard := preload("res://man_overboard/man_overboard.tscn").instantiate();
	
	man_overboard.position = %PlayerShip.position + random_point_on_circle(get_viewport().get_visible_rect().size.length() / 2 * 1.5)
	
	add_child(man_overboard)

func _upgrade_abilities() -> void:
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
		
		%CargoCounter.count -= %CargoCounter.cargo_cap
		%CargoCounter.cargo_cap += 1
		

func _on_cargo_hold_cargo_updated() -> void:
	if _dead:
		return

	%CargoCounter.count = %CargoCounter.count + 1
	
	if %CargoCounter.count >= %CargoCounter.cargo_cap and not %AbilityCards.visible:
		_upgrade_abilities()

func _on_kill_screen_finished() -> void:
	game_ended.emit(%SurvivorTime.score)

func _on_health_component_died() -> void:
	if _dead:
		return
		
	_dead = true
	%AbilityCards.hide()
	%KillScreen.die()

func _on_cooling_leveled_up() -> void:
	%AutoCannon.interval = 2.0 - (2.0 * $Abilities/Cooling.level() / 6.0)

func _on_piercing_leveled_up() -> void:
	%SideCannons.level_up_piercing()
	%AutoCannon.piercing += 1

func _on_side_cannons_leveled_up() -> void:
	%SideCannons.add_pair()

func _on_friendly_ships_leveled_up() -> void:
	%FriendlyShipSpawner.spawn()

func _on_barrels_leveled_up() -> void:
	%BarelDropping.interval = 5.0 / $Abilities/Barrels.level()

func _on_health_component_hitpoints_updated() -> void:
	%PlayerHitpoints.set_hitpoints(%HealthComponent.hitpoints)

func _on_health_component_max_hitpoints_updated() -> void:
	%PlayerHitpoints.set_max_hitpoints(%HealthComponent.max_hitpoints)
