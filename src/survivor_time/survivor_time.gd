extends HBoxContainer

var score: int = 0:
	set(value):
		if (value != score):
			score = value
			%ScoreValue.text = str(int(value))

func _on_score_timer_timeout() -> void:
	score += 1
