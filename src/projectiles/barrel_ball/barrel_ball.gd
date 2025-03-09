class_name BarrelBall
extends RigidBody2D

@export var damage : int
@export var piercing : int
@export var fly_time : float = 1
@export var cargo_damage: int = 0 ## will be used as create_barrel(damage), @see: barrel.gd
@export var is_frendly : bool = true

func _ready() -> void:
	$Timer.wait_time = fly_time
	original_scale = $Sprite2D.scale

const speed_limit = 300
const size_vec_scalor = 0.002
const size_time_scalor = 3
const time_speed_scalor = 2

var splash = preload("res://src/effects/splash/splash.tscn")
var impact = preload("res://src/effects/impact/impact.tscn")
var barrel = preload("res://src/barrel/barrel.tscn")
var original_scale: Vector2
var random = RandomNumberGenerator.new()

func arc(x: float) -> float:
	return 4 * x * (1 - x)

func _physics_process(delta: float) -> void:
	# WARNING: if fly_time < 1 then: it will scaleUp barrel quite a lot
	var new_scale = arc(lerp(0, 1, (fly_time - $Timer.time_left) / fly_time)) * 2
	$Sprite2D.scale = Vector2(original_scale.x * new_scale, original_scale.y * new_scale)
	$Sprite2D.rotate(delta * random.randi_range(3, 8))

func _on_body_entered(body: Node) -> void:
	for child in body.get_children():
		if child is HitpointBar:
			child.receive_damage(damage, HitpointBar.DamageType.PROJECTILE)

	add_collision_exception_with(body)

	piercing -= 1
	if piercing > 0:
		return

	var instance = impact.instantiate()
	instance.transform = transform
	get_parent().add_child(instance);
	queue_free()

func _on_timer_timeout() -> void:
	create_barrel(cargo_damage)
	queue_free()

func create_barrel(damage: int) -> void:
	var instance: Barrel = barrel.instantiate()
	instance.position = position
	instance.damage = damage
	get_parent().add_child(instance)
