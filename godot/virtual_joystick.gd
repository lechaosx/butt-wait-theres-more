extends Control

@export var joystick_radius := 100.0
@export var knob_radius := 30.0
@export var base_color := Color(1, 1, 1, 0.2)
@export var knob_color := Color(1, 1, 1, 0.6)

var direction := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		visible = event.pressed
		
		if event.pressed:
			direction = Vector2.ZERO
			global_position = event.global_position
		elif not event.pressed:
			direction = Vector2.ZERO
			
	if event is InputEventMouseMotion and visible: 
		direction = (event.global_position - global_position) / joystick_radius
		if direction.length() > 1.0:
			direction = direction.normalized()
			
		queue_redraw()
			
func _draw() -> void:
	draw_circle(Vector2.ZERO, joystick_radius, base_color)
	draw_circle(direction * joystick_radius, knob_radius, knob_color)
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		direction = Vector2.ZERO
		visible = false
