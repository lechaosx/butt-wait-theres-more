class_name PlayerShip extends CharacterBody2D

func damage(damage: int) -> void:
	%HealthComponent.health -= damage

func _physics_process(delta: float) -> void:
	if %HealthComponent.health > 0:
		%ShipPhysicsComponent.move(self, Input.get_action_strength("ui_up"), Input.get_action_strength("ui_down"), Input.get_axis("ui_left", "ui_right"), delta)
