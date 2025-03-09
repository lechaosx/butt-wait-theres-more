class_name PropertyResource
extends Resource

@export var min_value : int
@export var increment : int
@export var max_number_of_upgrades : int
var upgrades : int
@export var price : int

func value() -> int:
	return min_value + increment * upgrades

func upgrade() ->void:
	if max_number_of_upgrades > upgrades:
		upgrades += 1
