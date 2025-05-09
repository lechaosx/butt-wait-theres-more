class_name HealthComponent2 extends Node

signal health_updated
signal died

@export var max_health: int:
	set(value):
		max_health = value
		health = clamp(health, 0, max_health)

@export var health: int:
	set(value):
		var prev_health := health
	
		health = clamp(value, 0, max_health)

		if health != prev_health:
			health_updated.emit()
			
		if health == 0:
			died.emit()
