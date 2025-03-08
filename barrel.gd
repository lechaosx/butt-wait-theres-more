class_name Barrel
extends RigidBody2D

var random = RandomNumberGenerator.new()
var damage: int = random.randi_range(6, 18)
var damage_on_fire: int = 1
var damage_on_explosion: int = 3
var velocity: Vector2 = Vector2(0, 0)
var fire = preload("res://src/effects/fire/fire.tscn")
var explode_others = preload("res://src/projectiles/explode_ball/explode_ball.tscn")

func _ready() -> void:
	var hp: HitpointBar = $HitpointBar
	hp.set_max_hitpoints(damage)
	hp.fully_heal()
	hp.on_death.connect(self._on_barrel_is_dead)

func _physics_process(delta: float) -> void:
	var collisionInfo = move_and_collide(Vector2.ZERO)
	if collisionInfo:
		collide_with(collisionInfo)

func _on_barrel_is_dead(parent:Node) -> void:
	if parent is Barrel:
		var boom: Fire = fire.instantiate()
		var badaboom = func():
			var badaboom = explode_others.instantiate()
			badaboom.position = parent.position
			get_tree().root.add_child(badaboom)
			parent.queue_free()

		$".".add_child(boom)
		boom.scale = Vector2(2, 2)
		boom.start("boom1", 0.5, 0, badaboom)
		$HitpointBar.visible = false

func collide_with(info: KinematicCollision2D) -> void:
	var col = info.get_collider()
	#print_debug(col.name)
	match col.name:
		"PlayerShip":
			add_explosion()
			var hp: HitpointBar = $HitpointBar
			#var ship: Ship = col #TODO: getShipMass
			hp.receive_damage(damage_on_explosion)
		"CannonBall":
			add_fire()
			var hp: HitpointBar = $HitpointBar
			var ball: CannonBall = col
			hp.receive_damage(ball.damage)

func get_fire_range() -> Vector2:
	return Vector2(
		$Sprite2D.texture.get_width(),
		$Sprite2D.texture.get_height()
	)

func add_explosion() -> void:
	var boom_new: Fire = fire.instantiate()
	var boom_finished = func():
		$HitpointBar.receive_damage(damage_on_explosion)
		add_explosion()

	$".".add_child(boom_new)
	boom_new.start("boom1", 0.5, 0, boom_finished)

func add_fire(delta_pos: Vector2 = Vector2.ZERO) -> void:
	var fire_new: Fire = fire.instantiate()
	fire_new.translate(delta_pos)
	$".".add_child(fire_new)

	var fire_range = get_fire_range() / 2
	var fire_finished = func():
		$HitpointBar.receive_damage(damage_on_fire)
		add_fire(Vector2(
			random.randi_range(-1 * fire_range.x, fire_range.x),
			random.randi_range(-1 * fire_range.y, fire_range.y)
		))
		add_fire(Vector2(
			random.randi_range(-1 * fire_range.x, fire_range.x),
			random.randi_range(-1 * fire_range.y, fire_range.y)
		))

	fire_new.start("fire1", 1, 0, fire_finished)
