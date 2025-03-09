extends Node2D

func _on_timer_timeout() -> void:
	$AudioStreamPlayer2D.pitch_scale = 1.7 + randf() * 0.5
	$AudioStreamPlayer2D.play()
	$Timer.start( 5 + randf() * 10)
