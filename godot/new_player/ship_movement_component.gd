class_name ShipMovementComponent extends Node

@export var character: CharacterBody2D
@export var properties: ShipProperties

var acceleration_intent: float = 0.0
var brake_intent: float = 0.0
var steer_intent: float = 0.0

func _physics_process(delta: float) -> void:
	var direction := character.transform.y

	var acceleration := direction * properties.power * acceleration_intent

	acceleration -= character.velocity * properties.brakes * brake_intent * delta
	acceleration -= character.velocity * properties.friction * delta
	acceleration -= character.velocity * character.velocity.length() * properties.drag * delta

	var steer_direction := steer_intent * deg_to_rad(properties.steering_angle)

	var front := +direction * properties.ship_length / 2.0 + character.velocity * delta
	var back  := -direction * properties.ship_length / 2.0 - character.velocity.rotated(steer_direction) * delta

	var new_heading := back.direction_to(front)

	character.velocity = lerp(character.velocity, new_heading * character.velocity.length(), properties.traction) + acceleration * delta

	character.rotation = new_heading.rotated(deg_to_rad(-90)).angle()

	character.move_and_slide()
