class_name CannonBall
extends RigidBody2D

@export var damage : int
@export var piercing : int


const delay_die_time = 0.3
var delay_die : float

const speed_limit = 300
const size_vec_scalor = 0.002
const size_time_scalor = 3
const time_speed_scalor = 2

var splash = preload("res://src/effects/splash/splash.tscn")
var impact = preload("res://src/effects/impact/impact.tscn")

func _physics_process(delta: float) -> void:
	var new_scale = clamp(linear_velocity.length() * size_vec_scalor + clamp(delay_die, 0, delay_die_time) * size_time_scalor, 1.0, 5.0)
	$Sprite2D.scale = Vector2(new_scale,new_scale)

	if delay_die < delay_die_time:
		delay_die += delta * time_speed_scalor
	elif linear_velocity.length() < speed_limit:
		var instance = splash.instantiate()
		instance.transform = transform
		get_tree().root.add_child(instance);
		queue_free()

func _on_body_entered(body: Node) -> void:
	for child in body.get_children():
		if child is HitpointBar:
			child.receive_damage(1)
	
	add_collision_exception_with(body)
	
	piercing-=1
	if piercing:
		return
		
	var instance = impact.instantiate()
	instance.transform = transform
	get_tree().root.add_child(instance);
	queue_free()
