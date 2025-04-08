extends Node

func _on_play_button_pressed() -> void:
	$MainMenu.visible = false
	
	var sea: Sea = preload("res://sea.tscn").instantiate()
	sea.properties = %Shop.player_properties()
	add_child(sea)
	
	%Shop.balance += await sea.game_ended
	
	sea.queue_free()
	
	$MainMenu.visible = true
