extends HBoxContainer

var seconds = 0:
	set(value):
		if (value != seconds):
			seconds = value
			if value > %ProgressBar.max_value:
				%ProgressBar.max_value = value
			%ProgressBar.value = value
			%ScoreValue.text = str(int(value))

var score = 0:
	set(value):
		if (value != score):
			score = value
			%ScoreValue.text = str(int(value))

func init(max_from_previous_game: int) -> void:
	%ProgressBar.max_value = max_from_previous_game
