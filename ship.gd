class_name Ship extends CharacterBody2D

@export var steering_angle = 25
@export var power = 150
@export var friction = 20
@export var drag = 0.1
@export var traction = 100
@export var brakes = 100
@export var ship_length = 50

@export var controller: Node

func _physics_process(delta: float) -> void:
	var acceleration_intent = controller.get_acceleration_strength() if controller else 0
	var brake_intent        = controller.get_brake_strength() if controller else 0
	var steer_intent        = controller.get_steer_axis() if controller else 0
	
	var direction = transform.x
	
	var acceleration = direction * power * acceleration_intent
	
	acceleration -= velocity * brakes * brake_intent * delta
	
	acceleration -= velocity * friction * delta
	acceleration -= velocity * velocity.length() * drag * delta
	
	var steer_direction = steer_intent * deg_to_rad(steering_angle)
	
	var front = +direction * ship_length / 2.0 + velocity * delta
	var back  = -direction * ship_length / 2.0 - velocity.rotated(steer_direction) * delta

	var new_heading = back.direction_to(front)

	velocity = lerp(velocity, new_heading * velocity.length(), traction * delta) + acceleration * delta

	rotation = new_heading.angle()

	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider is RigidBody2D:
				collider.apply_central_impulse(-collision.get_normal()*0.1)
				

func _on_barrel_explode_to_ship(barrel: Barrel) -> void:
	print_debug(barrel)
