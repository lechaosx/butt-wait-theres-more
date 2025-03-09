extends Node2D

func _ready() -> void:
	#var speed = RandomNumberGenerator.new().randf_range(1, 2)
	var frame = 0 if RandomNumberGenerator.new().randi_range(0, 1) == 0 else 1
	$AnimatedSprite2D.play("default") #, speed)
	$AnimatedSprite2D.frame = frame #startingFrame
#alue1 if condition else value2
