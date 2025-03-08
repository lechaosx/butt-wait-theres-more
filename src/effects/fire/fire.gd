class_name Fire
extends Node2D

var current_callback: Callable
var current_animation: String

func _ready() -> void:
	$Duration.timeout.connect(_on_duration_timeout)
	$Wait.timeout.connect(_on_wait_timeout)
	$AnimatedSprite2D.visible = false
	#example: start("fire1", 3, empty_callback, 2)

# animation is done, call(callback)
func _on_duration_timeout() -> void:
	$AnimatedSprite2D.visible = false
	current_callback.call()
	queue_free()

# wait is done, start animation
func _on_wait_timeout() -> void:
	$Duration.start()
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play(current_animation)

# animation: {fire1}
func start(animation: String, duration: float, callback: Callable = empty_callback, wait: float = 0) -> void:
	current_animation = animation
	current_callback = callback
	$Duration.wait_time = duration
	$Wait.wait_time = wait
	$Wait.start()

func empty_callback() -> void:
	pass
