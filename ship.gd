class_name Ship extends CharacterBody2D

enum Type {	
	Player,
	Friendly,
	Enemy
}

static func is_good(ship_type: Type) -> bool:
	return ship_type == Type.Friendly or ship_type == Type.Player

@export var steering_angle = 25
@export var power = 100
@export var friction = 30
@export var drag = 0.1
@export var traction = 100
@export var brakes = 100
@export var ship_length = 100
@export var ramming_damage = 1

@export var type = Type.Enemy

@export var controller: Node

var _hitpoint_bar: HitpointBar = null

func _ready() -> void:
	match type:
		Type.Friendly:
			$AnimatedSprite2D.animation = "friendly"
		Type.Enemy:
			$AnimatedSprite2D.animation = "enemy"
		Type.Player:
			$AnimatedSprite2D.animation = "player"
	
	for child in get_children():
		if child is HitpointBar:
			add_hitpoint_bar(child)

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

	move_and_slide()

func add_hitpoint_bar(bar: HitpointBar) -> void:
	_hitpoint_bar = bar
	
	if get_children().find(bar) == -1:
		add_child(bar)
	
	_hitpoint_bar.hitpoint_update.connect(func(_n): _update_frames())
	_hitpoint_bar.max_hitpoints_update.connect(func(_n): _update_frames())
	_hitpoint_bar.damage_received.connect(func(_n, _d): _update_frames())
	_hitpoint_bar.heal_received.connect(func(_n): _update_frames())

func _update_frames() -> void:
	var health = 1.0 * _hitpoint_bar.hitpoints / _hitpoint_bar.max_hitpoints
	if health > 0.75:
		$AnimatedSprite2D.frame = 0
	elif health > 0.5:
		$AnimatedSprite2D.frame = 1
	elif health > 0.25:
		$AnimatedSprite2D.frame = 2
	else:
		$AnimatedSprite2D.frame = 3

func _on_ram_area_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is HitpointBar:
			if body is Ship:
				if body.is_good(body.type) != is_good(type):
					child.receive_damage(ramming_damage, HitpointBar.DamageType.RAMMING)
			else:
				child.receive_damage(ramming_damage, HitpointBar.DamageType.RAMMING)

	if controller.has_method("on_ramming"):
		controller.on_ramming()
