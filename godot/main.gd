extends Node

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
	
func _ready() -> void:
	try_load_game()
	%Shop.upgrades = [hitpoints, acceleration, steering, ram_damage, cannon_damage]

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
