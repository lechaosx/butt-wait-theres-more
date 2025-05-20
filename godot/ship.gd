class_name Ship extends CharacterBody2D

signal health_updated
signal max_health_updated

@export var steering_angle: float = 25
@export var power: float  = 100
@export var friction: float  = 30
@export var drag: float = 0.1
@export var traction: float = 100
@export var brakes: float = 100
@export var ship_length: float = 100

@export var ramming_damage: int = 1

@export var controller: Node

@export var max_health: int:
	set(value):
		if not is_node_ready(): await ready
		$HealthComponent.max_health = value
	get: return $HealthComponent.max_health

@export var health: int:
	set(value):
		if not is_node_ready(): await ready
		$HealthComponent.health = value
	get: return $HealthComponent.health

func _process(_delta: float) -> void:
		var ratio: float = 1.0 * health / max_health
		if ratio > 0.75:
			$AnimatedSprite2D.frame = 0
		elif ratio > 0.5:
			$AnimatedSprite2D.frame = 1
		elif ratio > 0.25:
			$AnimatedSprite2D.frame = 2
		else:
			$AnimatedSprite2D.frame = 3

func _physics_process(delta: float) -> void:
	var acceleration_intent: float = controller.get_acceleration_strength() if controller else 0.0
	var brake_intent: float        = controller.get_brake_strength()        if controller else 0.0
	var steer_intent: float        = controller.get_steer_axis()            if controller else 0.0

	var direction := transform.x

	var acceleration := direction * power * acceleration_intent

	acceleration -= velocity * brakes * brake_intent * delta

	acceleration -= velocity * friction * delta
	acceleration -= velocity * velocity.length() * drag * delta

	var steer_direction := steer_intent * deg_to_rad(steering_angle)

	var front := +direction * ship_length / 2.0 + velocity * delta
	var back  := -direction * ship_length / 2.0 - velocity.rotated(steer_direction) * delta

	var new_heading := back.direction_to(front)

	velocity = lerp(velocity, new_heading * velocity.length(), traction * delta) + acceleration * delta

	rotation = new_heading.angle()

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 50)

func _on_ram_area_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is HealthComponent:
			child.health -= ramming_damage

	if controller.has_method("on_ramming"):
		controller.on_ramming()


func _on_health_component_health_updated() -> void:
	health_updated.emit()


func _on_health_component_max_health_updated() -> void:
	max_health_updated.emit()
