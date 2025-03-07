class_name Barrel
extends RigidBody2D

var explosion_state: int = 0 # 1=fire, 2=boom, 3=signal
var velocity: Vector2 = Vector2(1, 1)


func _ready() -> void:
	$AnimatedSprite2D.visible = false

func _physics_process(delta: float) -> void:
	if explosion_state != 0:
		return
	var collisionInfo = move_and_collide(velocity * delta)
	if collisionInfo:
		velocity = velocity.bounce(collisionInfo.get_normal())
		explode()

func explode() -> void:
	# TODO: play animation (fire -> explosion)
	# TODO: when its done, remove from scene and emit signal(damage)
	explosion_state = 1
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("fire")

	explosion_state = 3
	SignalBus.BarrelExplodeToShip.emit(self)
	#$AnimatedSprite.stop()
