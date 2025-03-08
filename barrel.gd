class_name Barrel
extends RigidBody2D

# TODO: po impactu se nehybe
# TODO: ma damage
# TODO: rozmistit plaminky podle damage
# TODO: dodelat explosion

var velocity: Vector2 = Vector2(0, 0)
var fire = preload("res://src/effects/fire/fire.tscn")

func _ready() -> void:
	#explode()
	pass

func _physics_process(delta: float) -> void:
	var collisionInfo = move_and_collide(velocity * delta)
	if collisionInfo:
		velocity = velocity.bounce(collisionInfo.get_normal())
		explode()

func explode() -> void:
	var parent = $"."
	var fire1: Fire = fire.instantiate()
	var fire2: Fire = fire.instantiate()
	var fire3: Fire = fire.instantiate()
	var boom1: Fire = fire.instantiate()
	#TODO: random fire position
	fire1.position = position + Vector2(55, 55)
	fire2.position = position + Vector2(77, 55)
	fire3.position = position + Vector2(99, 55)
	boom1.position = position + Vector2(111, 55)
	parent.add_child(fire1)
	parent.add_child(fire2)
	parent.add_child(fire3)
	parent.add_child(boom1)

	var badaboom = func():
		SignalBus.BarrelExplodeToShip.emit(self)

	fire1.start("fire1", 3)
	fire2.start("fire1", 1, 0.5)
	fire3.start("fire1", 1.5, 0.75)
	boom1.start("boom1", 0.5, 3.5, badaboom)
