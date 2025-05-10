@tool extends HBoxContainer

@export var cargo_cap: int:
	set(value):
		cargo_cap = value
		
		if not is_node_ready(): await ready

		$ProgressBar.max_value = value

@export var count: int:
	set(value):
		count = value
		
		if not is_node_ready(): await ready
		
		$ProgressBar.value = value
