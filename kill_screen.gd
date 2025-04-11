extends Control

signal finished

func die() -> void:
	visible = true
	$AnimationPlayer.active = true
	%Hud.visible = false
	%CargoCounter.visible = false
	$Timer.start()

func _on_timer_timeout() -> void:
	finished.emit()
