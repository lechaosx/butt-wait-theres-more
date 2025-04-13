class_name PlayerShip extends CharacterBody2D

func _physics_process(_delta: float) -> void:
	if %HealthComponent.health > 0:
		%ShipMovementComponent.acceleration_intent = Input.get_action_strength("ui_up")
		%ShipMovementComponent.brake_intent = Input.get_action_strength("ui_down")
		%ShipMovementComponent.steer_intent = Input.get_axis("ui_left", "ui_right")
	else:
		%ShipMovementComponent.acceleration_intent = 0.0
		%ShipMovementComponent.brake_intent = 0.0
		%ShipMovementComponent.steer_intent = 0.0
	
