extends CanvasLayer

@export var health_component: HealthComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.hitpoints_updated.connect(update_hitpoints)
	health_component.max_hitpoints_updated.connect(update_max_hitpoints)
	update_max_hitpoints()
	update_hitpoints()

func update_hitpoints() -> void:
	$PlayerHitpoints.value = health_component.hitpoints
	$PlayerHitpoints/HBoxContainer/CurrentHp.text = str(health_component.hitpoints)

func update_max_hitpoints() -> void:
	$PlayerHitpoints.max_value = health_component.max_hitpoints
	$PlayerHitpoints/HBoxContainer/MaxHp.text = str(health_component.max_hitpoints)
