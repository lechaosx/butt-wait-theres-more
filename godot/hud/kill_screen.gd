extends Control

func die() -> Signal:
	visible = true
	$AnimationPlayer.active = true
	$Timer.start()
	
	return $Timer.timeout
