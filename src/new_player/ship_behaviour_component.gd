class_name ShipPhysicsComponent extends Node

@export var steering_angle = 25
@export var power = 100
@export var friction = 30
@export var drag = 0.1
@export var traction = 0.8
@export var brakes = 100
@export var ship_length = 50

func move(character: CharacterBody2D, acceleration_intent: float, brake_intent: float, steer_intent: float, delta: float) -> void:
	var direction = character.transform.y

	var acceleration = direction * power * acceleration_intent

	acceleration -= character.velocity * brakes * brake_intent * delta
	acceleration -= character.velocity * friction * delta
	acceleration -= character.velocity * character.velocity.length() * drag * delta

	var steer_direction = steer_intent * deg_to_rad(steering_angle)

	var front = +direction * ship_length / 2.0 + character.velocity * delta
	var back  = -direction * ship_length / 2.0 - character.velocity.rotated(steer_direction) * delta

	var new_heading = back.direction_to(front)

	character.velocity = lerp(character.velocity, new_heading * character.velocity.length(), traction) + acceleration * delta

	character.rotation = new_heading.rotated(deg_to_rad(-90)).angle()

	character.move_and_slide()
