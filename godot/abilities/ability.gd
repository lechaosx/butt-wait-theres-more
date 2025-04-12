class_name Ability extends Resource

signal leveled

@export var name: String = ""
@export var image: Texture = null
@export var current_level: int = 0
@export var max_level: int = 5

func level_up() -> void:
	if current_level >= max_level:
		return
		
	current_level += 1
	
	leveled.emit() 
