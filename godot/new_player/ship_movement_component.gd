class_name ShipMovementComponent extends Node

@export var character: CharacterBody2D

@export var steering_angle: float = 25
@export var power: float = 100
@export var friction: float = 30
@export var drag: float = 0.1
@export var traction: float = 0.8
@export var brakes: float = 100
@export var ship_length: float = 50

var acceleration_intent: float = 0.0
var brake_intent: float = 0.0
var steer_intent: float = 0.0

func _physics_process(delta: float) -> void:
	var direction := character.transform.y

	var acceleration := direction * power * acceleration_intent

	acceleration -= character.velocity * brakes * brake_intent * delta
	acceleration -= character.velocity * friction * delta
	acceleration -= character.velocity * character.velocity.length() * drag * delta

	var steer_direction := steer_intent * deg_to_rad(steering_angle)

	var front := +direction * ship_length / 2.0 + character.velocity * delta
	var back  := -direction * ship_length / 2.0 - character.velocity.rotated(steer_direction) * delta

	var new_heading := back.direction_to(front)

	character.velocity = lerp(character.velocity, new_heading * character.velocity.length(), traction) + acceleration * delta

	character.rotation = new_heading.rotated(deg_to_rad(-90)).angle()

	character.move_and_slide()
