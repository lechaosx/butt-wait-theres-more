class_name PlayerShip extends CharacterBody2D

@export var steering = 25
@export var power = 150
@export var friction = 20
@export var drag = 0.1
@export var traction = 100
@export var brakes = 100
@export var ship_length = 50

func _physics_process(delta: float) -> void:
	var direction = transform.x

	var acceleration = direction * power * Input.get_action_strength("ui_up")

	acceleration -= velocity * brakes * Input.get_action_strength("ui_down") * delta

	acceleration -= velocity * friction * delta
	acceleration -= velocity * velocity.length() * drag * delta

	var steer_direction = Input.get_axis("ui_left", "ui_right") * deg_to_rad(steering)

	var front = +direction * ship_length / 2.0 + velocity * delta
	var back  = -direction * ship_length / 2.0 - velocity.rotated(steer_direction) * delta

	var new_heading = back.direction_to(front)

	velocity = lerp(velocity, new_heading * velocity.length(), traction * delta) + acceleration * delta

	rotation = new_heading.angle()

	move_and_slide()

func _on_barrel_explode_to_ship(barrel: Barrel) -> void:
	print_debug(barrel)
