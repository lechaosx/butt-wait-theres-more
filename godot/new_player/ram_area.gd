class_name RamArea extends Area2D

@export var damage: int = 1
@export var target_group: String = "enemies"

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group(target_group):
		return
		
	if area is HurtboxComponent:
		area.apply_damage(damage)
