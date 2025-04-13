class_name HealthComponent2 extends Node

signal health_updated
signal died

@export var max_health := 10
@export var health := 10:
	set(value):
		var prev_health := health
	
		health = clamp(value, 0, max_health)

		if health != prev_health:
			health_updated.emit()
			
		if health == 0:
			died.emit()
