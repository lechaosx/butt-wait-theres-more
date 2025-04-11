extends RigidBody2D

@export var damage : int = 111

func _ready() -> void:
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.animation_finished.connect(self._on_animation_finished)

func _on_animation_finished() -> void:
	$AnimatedSprite2D.stop()
	queue_free()

func _on_body_entered(body: Node) -> void:
	if $AnimatedSprite2D.is_playing():
		return
	if body is Ship:
		if body.find_child("HealthComponent"):
			body.find_child("HealthComponent").receive_damage(damage, HealthComponent.DamageType.EXPLOSION)
		set_collision_layer_value(4, false)
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play("default")
