class_name HurtboxComponent extends Area2D

@export var health_component: HealthComponent

func apply_damage(damage: int) -> void:
	health_component.health -= damage
