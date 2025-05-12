class_name CannonBall
extends RigidBody2D

@export var damage : int = 1
@export var piercing : int = 0
@export var fly_time : float = 1

func _ready() -> void:
	$Timer.wait_time = fly_time

const speed_limit = 300
const size_vec_scalor = 0.002
const size_time_scalor = 3
const time_speed_scalor = 2

func arc(x: float) -> float:
	return 4 * x * (1 - x)

func _physics_process(_delta: float) -> void:
	var new_scale := arc(lerp(0, 1, (fly_time - $Timer.time_left) / fly_time)) * 2
	$Sprite2D.scale = Vector2(new_scale, new_scale)

func _on_body_entered(body: Node) -> void:
	for child in body.get_children():
		if child is HealthComponent:
			child.hitpoints -= damage
			$AudioStreamPlayer2D.play()
	
	add_collision_exception_with(body)
	
	if piercing > 0:
		piercing -= 1
		var impact := preload("res://effects/impact2/impact2.tscn").instantiate()
		impact.transform = transform
		get_tree().root.add_child(impact);
	else:
		var impact := preload("res://effects/impact/impact.tscn").instantiate()
		impact.transform = transform
		get_parent().add_child(impact);
		queue_free()

func _on_timer_timeout() -> void:
	var instance := preload("res://effects/splash/splash.tscn").instantiate()
	instance.position = position
	get_parent().add_child(instance);
	queue_free()
