extends HBoxContainer

var count: int = 0:
	set(value):
		$ProgressBar.value = value
		count = value
