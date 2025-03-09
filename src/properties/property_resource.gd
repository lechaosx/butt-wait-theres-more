class_name PropertyResource
extends Resource

@export var min_value : int
@export var increment : int
@export var price_increment : int
@export var min_price : int
var upgrades : int

func price() -> int:
	return min_price + price_increment * upgrades

func value() -> int:
	return min_value + increment * upgrades

func upgrade() ->void:
	upgrades += 1
