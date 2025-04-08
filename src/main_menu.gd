extends Node

var max_score: int = 0

func _on_play_button_pressed() -> void:
	var sea: Sea = preload("res://sea.tscn").instantiate()
	$MainMenu.visible = false
	$MainMenu/HBoxContainer/VBoxContainer/Shop.update_properties(sea)
	add_child(sea)
	
	var score = await sea.game_ended
	
	max_score = max(max_score, score)
	
	sea.queue_free()
	
	$MainMenu.visible = true
	$MainMenu/HBoxContainer/VBoxContainer/Shop.update_balance(score)
