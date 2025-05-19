class_name HealthBasedSpriteComponent extends AnimatedSprite2D

@export var health_component: HealthComponent

func _ready() -> void:
	health_component.health_updated.connect(_on_health_updated)
	
func _on_health_updated() -> void:
	frame = lerp(sprite_frames.get_frame_count(animation) - 1, 0, 1.0 * health_component.health / health_component.max_health)
