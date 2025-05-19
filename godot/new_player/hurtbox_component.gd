class_name HurtboxComponent extends Area2D

@export var health_component: HealthComponent2

func apply_damage(damage: int) -> void:
	health_component.health -= damage
