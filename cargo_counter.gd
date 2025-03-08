extends HBoxContainer

var count: int = 0:
	set(value):
		$Label.text = "%d" % value
		count = value
