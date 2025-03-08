extends RigidBody2D

@export var damage : int = 1

const delay_die_time = 0.3
var delay_die : float

const speed_limit = 200
const size_vec_scalor = 0.002
const size_time_scalor = 3
const time_speed_scalor = 2

var splash = preload("res://src/effects/splash/splash.tscn")

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
	if body is Ship:
		body.receive_damage(damage)
		set_collision_mask_value(4, false)
		queue_free()
