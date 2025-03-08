class_name Barrel
extends RigidBody2D

var random = RandomNumberGenerator.new()
var damage: int = random.randi_range(6, 18)
var damage_on_fire: int = 1

func _ready() -> void:
	var hp: HitpointBar = $HitpointBar
	hp.set_max_hitpoints(damage)
	hp.fully_heal()
	hp.on_death.connect(self._on_barrel_is_dead)

func _on_barrel_is_dead(parent:Node) -> void:
	if parent is Barrel:
		# when animation finished, it will remove barrel
		var ee_barel = $Effects/EndExplosion
		var remove_barrel = func():
			queue_free()
		ee_barel.visible = true
		ee_barel.animation_finished.connect(remove_barrel)
		ee_barel.play("default")
