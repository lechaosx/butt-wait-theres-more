extends Control

func die():
	visible = true
	$AnimationPlayer.active = true
	%Hud.visible = false
