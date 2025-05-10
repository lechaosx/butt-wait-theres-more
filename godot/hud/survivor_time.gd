extends HBoxContainer

var score: int = 0:
	set(value):
		score = value

		if not is_node_ready(): await ready

		%ScoreValue.text = str(score)

func _on_score_timer_timeout() -> void:
	score += 1
