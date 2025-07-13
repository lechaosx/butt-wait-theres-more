@tool class_name HealthComponent extends Node

signal max_health_updated
signal health_updated

@export var max_health: int = 5:
	set(value):
		if value != max_health:
			max_health = value
			max_health_updated.emit()
			health = clamp(health, 0, max_health)

@export var health: int = 5:
	set(value):
		value = clamp(value, 0, max_health)
		if value != health:
			
			var damage := health - value
			if damage > 0:
				_spawn_popup(damage)
				
			health = value
			health_updated.emit()

func _spawn_popup(value: int) -> void:
	var popup := preload("res://hitpoints/damage_popup.tscn").instantiate()
	popup.set_text(value)
	create_tween().tween_property(popup, "position", Vector2(1, randf_range(-1, 1)) * 20, 0.8)
	add_sibling(popup)
