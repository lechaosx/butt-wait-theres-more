@tool extends Node

const savefile := "user://savefile.txt"

@export var hitpoints: Upgrade
@export var acceleration: Upgrade
@export var steering: Upgrade
@export var ram_damage: Upgrade
@export var cannon_damage: Upgrade

func save_game() -> void:
	var data := {
		"balance": %Shop.balance,
		"hitpoints": hitpoints.level,
		"acceleration": acceleration.level,
		"steering": steering.level,
		"ram_damage": ram_damage.level,
		"cannon_damage": cannon_damage.level
	}

	var file := FileAccess.open(savefile, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	
func try_load_game() -> void:
	if not FileAccess.file_exists(savefile):
		return
	
	var file := FileAccess.open(savefile, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	
	%Shop.balance = data["balance"]
	hitpoints.level = data["hitpoints"]
	acceleration.level = data["acceleration"]
	steering.level = data["steering"]
	ram_damage.level = data["ram_damage"]
	cannon_damage.level = data["cannon_damage"]

func _get_first_focusable_control(node: Node) -> Control:
	if node is CanvasItem and not node.visible:
		return null
		
	if node is Control and node.focus_mode != Control.FOCUS_NONE:
		return node as Control
		
	for child in node.get_children():
		var result := _get_first_focusable_control(child)
		if result:
			return result
			
	return null
	
func _is_ui_navigation_action(event: InputEvent) -> bool:
	return event.is_action_pressed("ui_up") \
		or event.is_action_pressed("ui_down") \
		or event.is_action_pressed("ui_left") \
		or event.is_action_pressed("ui_right") \
		or event.is_action_pressed("ui_focus_next") \
		or event.is_action_pressed("ui_focus_prev")
		
func _unhandled_input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == null and _is_ui_navigation_action(event):
		# This is ugly af, feel free to refactor it
		if $MainMenu.visible or get_tree().paused:
			var first_control := _get_first_focusable_control(self)
			if first_control:
				first_control.grab_focus()
			
func _ready() -> void:
	%Shop.upgrades = [hitpoints, acceleration, steering, ram_damage, cannon_damage]
	
	if not Engine.is_editor_hint():
		try_load_game()

func _on_play_button_pressed() -> void:
	save_game() # Save when leaving shop and entering the game
	
	$MainMenu.visible = false
	
	var sea: Sea = preload("res://sea.tscn").instantiate()
	sea.hitpoints = hitpoints.value()
	sea.acceleration = acceleration.value()
	sea.steering = steering.value()
	sea.ram_damage = ram_damage.value()
	sea.cannon_damage = cannon_damage.value()
	add_child(sea)
	
	%Shop.balance += await sea.game_ended
	
	sea.queue_free()
	
	save_game() # Also save when leaving the game and entering the shop
	
	$MainMenu.visible = true
