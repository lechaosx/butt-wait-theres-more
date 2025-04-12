class_name Upgrade extends Resource

@export var name: String = ""

@export var start_value: int = 0
@export var value_increment: int = 0

@export var start_price : int = 0
@export var price_increment : int = 0

var level: int = 0

func value() -> int:
	return start_value + value_increment * level
	
func price() -> int:
	return start_price + price_increment * level
