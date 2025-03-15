class_name HealthBasedSpriteComponent extends Node2D

@export var sprite_frames: SpriteFrames
@export var animation: StringName
@export var health_component: HealthComponent

func _ready():
	%AnimatedSprite2D.sprite_frames = sprite_frames
	%AnimatedSprite2D.animation = animation
	health_component.health_updated.connect(health_updated)
	
func health_updated():
	%AnimatedSprite2D.frame = lerp(sprite_frames.get_frame_count(animation) - 1, 0, 1.0 * health_component.health / health_component.max_health)
