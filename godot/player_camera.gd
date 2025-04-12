extends Camera2D

func _process(_delta: float) -> void:
	var zoom_factor: float = lerp(1.0, 0.5, get_parent().velocity.length() / 400.0)
	zoom = Vector2(zoom_factor, zoom_factor)
