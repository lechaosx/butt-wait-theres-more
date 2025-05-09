class_name RamArea extends Area2D

@export var damage: int = 1

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		area.apply_damage(damage)
