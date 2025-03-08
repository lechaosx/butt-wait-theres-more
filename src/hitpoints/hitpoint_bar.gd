class_name HitpointBar
extends Node2D

@export var max_hitpoints: int = 10
var damage_popup_node: PackedScene = preload("res://src/hitpoints/damage_popup/damage_popup.tscn")

var hitpoints: int:
	set(value):
		hitpoints = value
		if $ProgressBar:
			$ProgressBar.value = value
		hitpoint_update.emit(value)

signal on_death(parent:Node)
signal hitpoint_update(new_value:int)
signal max_hitpoints_update(new_value:int)

func popup(value:int):
	var popup_instance = damage_popup_node.instantiate()
	popup_instance.position = $PopupLocation.position
	popup_instance.set_text(value)
	create_tween().tween_property(popup_instance, "position", Vector2(1, randf_range(-1,1))*20, 0.8)
	add_child(popup_instance)

func receive_damage(damage: int) -> void:
	hitpoints -= damage
	popup(damage)
	if hitpoints <= 0:
		on_death.emit(get_parent())

func receive_heal(heal:int):
	hitpoints = clamp(hitpoints+heal, 0, max_hitpoints)

func fully_heal():
	hitpoints = max_hitpoints

func _ready() -> void:
	if $ProgressBar:
			$ProgressBar.max_value = max_hitpoints
	fully_heal()

func set_max_hitpoints(value:int):
	max_hitpoints = value
	if $ProgressBar:
			$ProgressBar.max_value = max_hitpoints

func _process(delta: float) -> void:
	rotation = - get_parent().rotation
