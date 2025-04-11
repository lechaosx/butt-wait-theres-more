extends Area2D

func explosion(damage: int) -> void:
	for entry1 in get_overlapping_bodies():
		for entry2 in entry1.get_children():
			if entry2 is HealthComponent:
				entry2.receive_damage(damage)
