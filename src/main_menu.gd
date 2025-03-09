extends Node

@onready var sea_scene = preload("res://sea.tscn")
var active_sea
var max_score:int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_over(score:int) -> void:
	if score > max_score:
		max_score = score
	get_tree().root.remove_child(active_sea)
	active_sea.queue_free()
	$MainMenu.visible = true
	$MainMenu/HBoxContainer/VBoxContainer/Shop.update_balance(score)

func _on_button_pressed() -> void:
	var sea: Sea = sea_scene.instantiate()
	$MainMenu.visible = false
	sea.game_ended.connect(self._on_game_over)
	get_tree().root.add_child(sea)
	$MainMenu/HBoxContainer/VBoxContainer/Shop.update_properties(sea)
	active_sea = sea
	sea.game_started.emit(max_score)
