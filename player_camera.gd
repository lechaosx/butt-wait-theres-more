extends Camera2D

func _process(delta):
	var zoom_factor = lerp(1.0, 0.5, $"..".velocity.length() / 400)
	zoom = Vector2(zoom_factor, zoom_factor)
