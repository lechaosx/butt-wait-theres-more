extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_hp_bar : HitpointBar = %PlayerShip/HitpointBar
	player_hp_bar.hitpoint_update.connect(self.update_hitpoints)
	player_hp_bar.max_hitpoints_update.connect(self.update_max_hitpoints)
	player_hp_bar.visible=false
	update_max_hitpoints(player_hp_bar.max_hitpoints)
	update_hitpoints(player_hp_bar.hitpoints)
	%Wind.wind_changed.connect(self.update_wind)
	update_wind(%Wind._speed, %Wind._direction)
	pass # Replace with function body.

func update_wind(speed:float, direction:Vector2)->void:
	$WindDirection.rotation = direction.angle()
	$WindSpeed.text = str(int(speed))

func update_hitpoints(value:int)->void:
	$PlayerHitpoints.value = value

func update_max_hitpoints(value:int) -> void:
	$PlayerHitpoints.max_value = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
