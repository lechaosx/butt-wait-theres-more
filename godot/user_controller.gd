extends Node

func get_acceleration_strength() -> float:
	return Input.get_action_strength("ui_up")
	
func get_brake_strength() -> float:
	return Input.get_action_strength("ui_down")

func get_steer_axis() -> float:
	return Input.get_axis("ui_left", "ui_right")
