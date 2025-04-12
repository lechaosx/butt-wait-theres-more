extends Area2D

@export var damage: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):  # Check if the body has an "apply_damage" method
		body.apply_damage(damage)  # Call the method and pass the damage amount
	queue_free()  # Destroy the projectile after impact
