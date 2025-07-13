@tool extends ProgressBar

func set_hitpoints(hitpoints: int) -> void:
	value = hitpoints
	%CurrentHp.text = str(hitpoints)

func set_max_hitpoints(max_hitpoints: int) -> void:
	max_value = max_hitpoints
	%MaxHp.text = str(max_hitpoints)
