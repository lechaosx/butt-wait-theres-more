extends Node

func get_acceleration_strength():
	return Input.get_action_strength("ui_up")
	
func get_brake_strength():
	return Input.get_action_strength("ui_down")

func get_steer_axis():
	return Input.get_axis("ui_left", "ui_right")
