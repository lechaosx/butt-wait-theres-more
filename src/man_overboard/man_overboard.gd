extends Area2D

@export var heal_amount: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$AnimatedSprite2D.autoplay = "default"
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		for child in body.get_children():
			if child is HitpointBar:
				child.receive_heal(heal_amount)
				queue_free()
				return
