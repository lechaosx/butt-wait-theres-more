class_name Barrel
extends RigidBody2D

# TODO: po impactu se nehybe
# TODO: ma damage
# TODO: rozmistit plaminky podle damage
# TODO: dodelat explosion
var random = RandomNumberGenerator.new()
@export var damage: int = random.randi_range(5, 11)
var collide_counter: int = 0
var onfire_counter: int = 0
var velocity: Vector2 = Vector2(0, 0)
var fire = preload("res://src/effects/fire/fire.tscn")

func _ready() -> void:
	var hp: HitpointBar = $HitpointBar
	hp.set_max_hitpoints(5) #damage)
	hp.fully_heal()
	hp.on_death.connect(self._on_barrel_is_dead)
	pass

func _physics_process(delta: float) -> void:
	##var collisionInfo = move_and_collide(velocity * delta)
	var collisionInfo = move_and_collide(Vector2.ZERO)
	if collisionInfo:
		##velocity = velocity.bounce(collisionInfo.get_normal())
		##freeze = true
		collide_with(collisionInfo)

	#var motion = velocity * delta
	#if test_motion(Transform2D(), motion):
		#print("Collision detected!")

	#var motion = velocity * delta
	#var motion_result = PhysicsTestMotionResult2D.new()
	## Test if the body would collide without actually moving it
	#if PhysicsServer2D.body_test_motion(get_rid(), motion, motion_result):
		#print("Collision detected with:", motion_result.collider)

	#if hitpoints <= 0:
		#final_explosion()

	pass

func _on_barrel_is_dead(parent:Node) -> void:
	if parent is Barrel:
		var boom: Fire = fire.instantiate()
		var badaboom = func():
			#SignalBus.BarrelExplode.emit(self)
			parent.queue_free()
		$".".add_child(boom)
		boom.start("boom1", 0.5, 0, badaboom)
		$HitpointBar.visible = false

func collide_with(info: KinematicCollision2D) -> void:
	var col = info.get_collider()
	match col.name:
		"PlayerShip":
			add_fire()
			add_fire()
			add_fire()
		"CannonBall":
			add_fire()
			var hp: HitpointBar = $HitpointBar
			var ball: CannonBall = col
			hp.receive_damage(ball.damage)
		#_:
			#var a = get_colliding_bodies()
		#var b = get_contact_count()
		#var x = collisionInfo.get_collider() #.name == "Borders":
		##hit_sound.play()
		#print_debug(a, b, x, x.name)


	#collide_cod
	pass

func get_fire_range() -> Vector2:
	return Vector2(
		$Sprite2D.texture.get_width(),
		$Sprite2D.texture.get_height()
	)

func add_fire(delta_pos: Vector2 = Vector2.ZERO) -> void:
	var parent = $"."
	var fire1: Fire = fire.instantiate()
	fire1.translate(delta_pos)
	#fire1.position = position + delta_pos
	parent.add_child(fire1)
	onfire_counter += 1

	var fire_range = get_fire_range() / 2
	var fire_finished = func():
		add_fire(Vector2(
			random.randi_range(-1 * fire_range.x, fire_range.x),
			random.randi_range(-1 * fire_range.y, fire_range.y)
		))
		#SignalBus.BarrelExplodeToShip.emit(self)
#
	#fire1.start("fire1", 3)
	#fire2.start("fire1", 1, 0.5)
	#fire3.start("fire1", 1.5, 0.75)
	fire1.start("fire1", 1, 0, fire_finished)


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
