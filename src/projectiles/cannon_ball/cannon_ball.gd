class_name CannonBall
extends RigidBody2D

@export var damage : int = 1
@export var piercing : int = 0
@export var fly_time : float = 1
@export var from_good_ship : bool = true

func _ready() -> void:
	$Timer.wait_time = fly_time

const speed_limit = 300
const size_vec_scalor = 0.002
const size_time_scalor = 3
const time_speed_scalor = 2

var splash = preload("res://src/effects/splash/splash.tscn")
var impact = preload("res://src/effects/impact/impact.tscn")

func arc(x: float) -> float:
	return 4 * x * (1 - x)

func _physics_process(delta: float) -> void:
	var new_scale = arc(lerp(0, 1, (fly_time - $Timer.time_left) / fly_time)) * 2
	$Sprite2D.scale = Vector2(new_scale, new_scale)

func _on_body_entered(body: Node) -> void:
	
	# do not shoot same friendly type
	if body is Ship && Ship.is_good(body.type) == from_good_ship:
		add_collision_exception_with(body) # lul
		return
	
	for child in body.get_children():
		if child is HitpointBar:
			child.receive_damage(damage, HitpointBar.DamageType.PROJECTILE)
			$AudioStreamPlayer2D.play()
	
	add_collision_exception_with(body)
	
	if piercing > 0:
		piercing -= 1
		return
		
	var instance = impact.instantiate()
	instance.transform = transform
	get_parent().add_child(instance);
	queue_free()

func _on_timer_timeout() -> void:
	var instance = splash.instantiate()
	instance.position = position
	get_parent().add_child(instance);
	queue_free()
