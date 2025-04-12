class_name Ability extends Node

signal leveled_up

@export var info: AbilityInfo

var _level: int = 0

func level() -> int:
	return _level

func level_up() -> void:
	if _level >= info.max_level:
		return
	
	_level += 1
	
	leveled_up.emit()
