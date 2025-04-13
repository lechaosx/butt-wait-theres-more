class_name Ship extends CharacterBody2D

enum Type {
	Player,
	Friendly,
	Enemy
}

static func is_good(ship_type: Type) -> bool:
	return ship_type == Type.Friendly or ship_type == Type.Player

@export var steering_angle: float = 25
@export var power: float  = 100
@export var friction: float  = 30
@export var drag: float = 0.1
@export var traction: float = 100
@export var brakes: float = 100
@export var ship_length: float = 100

@export var ramming_damage: int = 1

@export var type := Type.Enemy

@export var controller: Node

func _ready() -> void:
	match type:
		Type.Friendly:
			$AnimatedSprite2D.animation = "friendly"
		Type.Enemy:
			$AnimatedSprite2D.animation = "enemy"
		Type.Player:
			$AnimatedSprite2D.animation = "player"
	
func _process(_delta: float) -> void:
	for child in get_children():
		if child is HealthComponent:
			var health: float = 1.0 * child.hitpoints / child.max_hitpoints
			if health > 0.75:
				$AnimatedSprite2D.frame = 0
			elif health > 0.5:
				$AnimatedSprite2D.frame = 1
			elif health > 0.25:
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
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 50)

func _on_ram_area_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is HealthComponent:
			if body is Ship:
				if body.is_good(body.type) != is_good(type):
					child.hitpoints -= ramming_damage
			else:
				child.hitpoints -= ramming_damage

	if controller.has_method("on_ramming"):
		controller.on_ramming()
