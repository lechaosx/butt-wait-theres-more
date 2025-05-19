class_name BarrelBall extends RigidBody2D

@export var damage : int
@export var piercing : int
@export var fly_time : float = 1

func _ready() -> void:
	$Timer.wait_time = fly_time
	original_scale = $Sprite2D.scale

const speed_limit = 300
const size_vec_scalor = 0.002
const size_time_scalor = 3
const time_speed_scalor = 2

var original_scale: Vector2

func arc(x: float) -> float:
	return 4 * x * (1 - x)

func _physics_process(delta: float) -> void:
	# WARNING: if fly_time < 1 then: it will scaleUp barrel quite a lot
	var new_scale := arc(lerp(0, 1, (fly_time - $Timer.time_left) / fly_time)) * 2
	$Sprite2D.scale = Vector2(original_scale.x * new_scale, original_scale.y * new_scale)
	$Sprite2D.rotate(delta * randi_range(3, 8))

func _on_body_entered(body: Node) -> void:
	add_collision_exception_with(body)
	for child in body.get_children():
		if child is HealthComponent:
			child.health -= damage

			piercing -= 1
			if piercing <= 0:
				var impact := preload("res://effects/impact/impact.tscn").instantiate()
				impact.transform = transform
				get_parent().add_child(impact);
				queue_free()

func _on_timer_timeout() -> void:
	var barrel := preload("res://barrel/barrel.tscn").instantiate()
	barrel.position = position
	get_parent().add_child(barrel)
	queue_free()
