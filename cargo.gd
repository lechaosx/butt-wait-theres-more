extends Area2D

func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is CargoHold:
			child.add_cargo(1)
			queue_free()
