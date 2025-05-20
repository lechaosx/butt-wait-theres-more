extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$AnimatedSprite2D.autoplay = "default"
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if "health" in body:
			body.health += 1
			queue_free()
			return