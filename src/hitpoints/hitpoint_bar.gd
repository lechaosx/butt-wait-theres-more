class_name HitpointBar
extends Node2D

@export var max_hitpoints: int
var damage_popup_node: PackedScene = preload("res://src/hitpoints/damage_popup/damage_popup.tscn")

enum DamageType {
	PROJECTILE,
	RAMMING,
	FIRE,
	EXPLOSION,
}

var hitpoints: int:
	set(value):
		hitpoints = value
		$ProgressBar.value = value
		hitpoint_update.emit(value)
		if hitpoints <= 0:
			on_death.emit()


signal on_death
signal hitpoint_update(new_value:int)
signal max_hitpoints_update(new_value:int)
signal damage_received(value: int, type: DamageType)
signal heal_received(value:int)

func popup(value:int):
	var popup_instance = damage_popup_node.instantiate()
	popup_instance.position = $PopupLocation.position
	popup_instance.set_text(value)
	create_tween().tween_property(popup_instance, "position", Vector2(1, randf_range(-1,1))*20, 0.8)
	add_child(popup_instance)

func receive_damage(damage: int, type : DamageType) -> void:
	hitpoints -= damage
	damage_received.emit(damage, type)
	popup(damage)
	
func receive_heal(heal:int):
	heal_received.emit(heal)
	hitpoints = clamp(hitpoints+heal, 0, max_hitpoints)

func _ready() -> void:
	$ProgressBar.max_value = max_hitpoints
	hitpoints = max_hitpoints

func set_max_hitpoints(value: int):
	max_hitpoints = value
	hitpoints = max_hitpoints
	$ProgressBar.max_value = value
	max_hitpoints_update.emit(value)

func _process(_delta: float) -> void:
	rotation = - get_parent().rotation
