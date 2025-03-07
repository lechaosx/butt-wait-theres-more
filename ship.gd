class_name Ship extends CharacterBody2D

@export var max_speed = 10000
@export var drag = 0.1
@export var turn_speed = 2

func _physics_process(delta):
	var speed = Input.get_axis("ui_down", "ui_up") * max_speed * delta

	if speed != 0:
		rotation += Input.get_axis("ui_left", "ui_right") * turn_speed * delta
		velocity = Vector2(speed, 0).rotated(rotation)
	else:
		velocity = velocity * (1 - drag)

	move_and_slide()
