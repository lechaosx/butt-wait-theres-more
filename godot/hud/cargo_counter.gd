extends HBoxContainer

var cargo_cap: int = 1:
	set(value):
		if (value != cargo_cap):
			cargo_cap = value
			$ProgressBar.max_value = value

func _ready() -> void:
	$ProgressBar.max_value = cargo_cap

var count: int = 0:
	set(value):
		if (value != count):
			$ProgressBar.value = value
			count = value
