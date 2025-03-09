class_name Barrel
extends RigidBody2D

var random = RandomNumberGenerator.new()
@export var damage_min: int = 6
@export var damage_max: int = 18
@export var damage: int = 0 ## if damage == 0 then: rand(damage_min, damage_max)
var fire = preload("res://src/barrel/barrel_fire.tscn")

func _ready() -> void:
	if damage == 0:
		damage = random.randi_range(damage_min, damage_max)
	var hp: HitpointBar = $HitpointBar
	hp.set_max_hitpoints(damage)
	hp.fully_heal()
	hp.on_death.connect(self._on_barrel_is_dead)
	hp.damage_received.connect(self._on_barrel_damage_received)

func _on_barrel_is_dead(parent:Node) -> void:
	if parent is Barrel:
		# when animation finished, it will remove barrel
		var ee_barel = $Effects/EndExplosion
		var remove_barrel = func():
			queue_free()
		ee_barel.visible = true
		ee_barel.animation_finished.connect(remove_barrel)
		ee_barel.play("default")
		$HitpointBar.visible = false
		$Area2D.explosion(damage)

func _on_barrel_damage_received(value: int, type: HitpointBar.DamageType) -> void:
	if type == HitpointBar.DamageType.RAMMING:
		_on_barrel_is_dead(self)
	else:
		update_fire_per_hitpoints()

func update_fire_per_hitpoints() -> void:
	var hp: HitpointBar = $HitpointBar
	var hpp: = $HitpointBar/ProgressBar
	var percent = int((hpp.value / hpp.max_value) * 100)
	var p_limit = 22
	var max_fire = (100 / p_limit) - (percent / p_limit)
	if max_fire == 0 and percent < 100:
		add_fire(1)
	else:
		add_fire(max_fire)

func add_fire(max: int) -> void:
	var parent = $"."
	for i in range(0, max):
		var new_fire = fire.instantiate()
		new_fire.translate(Vector2(
			random.randi_range(-13, +13),
			random.randi_range(-18, +3)
		))
		parent.add_child(new_fire)
