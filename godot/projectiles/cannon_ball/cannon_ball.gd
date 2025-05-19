@tool extends RigidBody2D

@export var damage: int = 1
@export var piercing: int = 0

@export var friendly_groups: Array[String] = []

@export var fly_time : float = 1:
	set(value):
		if not is_node_ready(): await ready
		$Timer.wait_time = value
	get: return $Timer.wait_time
	
func _friendly(node: Node) -> bool:
	for group in friendly_groups:
		if node.is_in_group(group):
			return true
	return false

func _arc(x: float) -> float:
	return 4 * x * (1 - x)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
			return
		
	var new_scale := _arc(lerp(0, 1, (fly_time - $Timer.time_left) / fly_time)) * 2
	$Sprite2D.scale = Vector2(new_scale, new_scale)

func _on_body_entered(body: Node) -> void:
	if _friendly(body):
		return
		
	for child in body.get_children():
		if child is HealthComponent:
			child.hitpoints -= damage
			$AudioStreamPlayer2D.play()
	
	add_collision_exception_with(body)
	
	if piercing > 0:
		piercing -= 1
		var impact := preload("res://effects/impact2/impact2.tscn").instantiate()
		impact.transform = transform
		add_sibling(impact);
	else:
		var impact := preload("res://effects/impact/impact.tscn").instantiate()
		impact.global_position = global_position
		add_sibling(impact);
		queue_free()

func _on_timer_timeout() -> void:
	var splash := preload("res://effects/splash/splash.tscn").instantiate()
	splash.global_position = global_position
	add_sibling(splash);
	queue_free()
