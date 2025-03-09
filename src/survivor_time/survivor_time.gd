extends HBoxContainer

var seconds = 0:
	set(value):
		if (value != seconds):
			seconds = value
			#print_debug($ProgressBar.value, " ", value)
			if value > $ProgressBar.max_value:
				$ProgressBar.max_value = value
			$ProgressBar.value = value

func init(max_from_previous_game: int) -> void:
	$ProgressBar.max_value = max_from_previous_game
