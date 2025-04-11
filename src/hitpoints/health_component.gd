class_name HealthComponent extends Node2D

enum DamageType {
	PROJECTILE,
	RAMMING,
	FIRE,
	EXPLOSION,
}

signal on_death
signal hitpoint_update(new_value: int)
signal max_hitpoints_update(new_value: int)
signal damage_received(value: int, type: DamageType)
signal heal_received(value: int)

@export var max_hitpoints: int:
	set(value):
		max_hitpoints = value
		max_hitpoints_update.emit(value)

@export var hitpoints: int:
	set(value):
		hitpoints = value
		hitpoint_update.emit(value)
		if hitpoints <= 0:
			on_death.emit()

func popup(value: int) -> void:
	var popup_instance = preload("res://src/hitpoints/damage_popup/damage_popup.tscn").instantiate()
	popup_instance.set_text(value)
	create_tween().tween_property(popup_instance, "position", Vector2(1, randf_range(-1, 1)) * 20, 0.8)
	add_child(popup_instance)

func receive_damage(damage: int, type: DamageType) -> void:
	hitpoints -= damage
	damage_received.emit(damage, type)
	popup(damage)
	
func receive_heal(heal: int) -> void:
	heal_received.emit(heal)
	hitpoints = clamp(hitpoints + heal, 0, max_hitpoints)

func _ready() -> void:
	hitpoints = max_hitpoints

func _process(_delta: float) -> void:
	rotation = - get_parent().rotation
