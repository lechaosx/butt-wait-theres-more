class_name HealthComponent extends Node2D

signal died
signal hitpoints_updated
signal max_hitpoints_updated

@export var max_hitpoints: int = 1:
	set(value):
		max_hitpoints = value
		max_hitpoints_updated.emit()

@export var hitpoints: int = max_hitpoints:
	set(value):
		var damage := hitpoints - value
		
		hitpoints = clamp(value, 0, max_hitpoints)
		
		if damage > 0:
			spawn_popup(damage)
			
		hitpoints_updated.emit()
		
		if hitpoints <= 0:
			died.emit()

func spawn_popup(value: int) -> void:
	var popup_instance := preload("res://hitpoints/damage_popup/damage_popup.tscn").instantiate()
	popup_instance.set_text(value)
	create_tween().tween_property(popup_instance, "position", Vector2(1, randf_range(-1, 1)) * 20, 0.8)
	add_child(popup_instance)

func _ready() -> void:
	hitpoints = max_hitpoints

func _process(_delta: float) -> void:
	rotation = - get_parent().rotation
