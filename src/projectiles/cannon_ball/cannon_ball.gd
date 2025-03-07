extends RigidBody2D

const delay_die_time = 0.5
var delay_die : float

const speed_limit = 20

func _physics_process(delta: float) -> void:
	if delay_die < delay_die_time:
		delay_die += delta
	elif linear_velocity.length() < speed_limit:
		queue_free()
