@tool extends HBoxContainer

@export var cargo_cap: int:
	set(value):
		if not is_node_ready(): await ready
		$ProgressBar.max_value = value
	get: return $ProgressBar.max_value

@export var count: int:
	set(value):
		if not is_node_ready(): await ready
		$ProgressBar.value = value
	get: return $ProgressBar.value
