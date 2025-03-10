extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_hp_bar : HitpointBar = %PlayerShip/HitpointBar
	player_hp_bar.hitpoint_update.connect(self.update_hitpoints)
	player_hp_bar.max_hitpoints_update.connect(self.update_max_hitpoints)
	player_hp_bar.visible=false
	update_max_hitpoints(player_hp_bar.max_hitpoints)
	update_hitpoints(player_hp_bar.hitpoints)
	pass # Replace with function body.

func update_hitpoints(value:int)->void:
	$PlayerHitpoints.value = value

func update_max_hitpoints(value:int) -> void:
	$PlayerHitpoints.max_value = value
