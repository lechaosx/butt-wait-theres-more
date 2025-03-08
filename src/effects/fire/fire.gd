class_name Fire
extends Node2D

const GROUP_ANIM = "animations"
var current_callback: Callable
var current_animation: String

func _ready() -> void:
	$Duration.timeout.connect(_on_duration_timeout)
	$Wait.timeout.connect(_on_wait_timeout)
	for entry in get_tree().get_nodes_in_group(GROUP_ANIM):
		entry.visible = false

# animation is done, call(callback)
func _on_duration_timeout() -> void:
	get_anim(current_animation).visible = false
	current_callback.call()
	queue_free()

# wait is done, start animation
func _on_wait_timeout() -> void:
	$Duration.start()
	var anim = get_anim(current_animation)
	anim.visible = true
	anim.play(current_animation)

# animation: {fire1}
func start(animation: String, duration: float, wait: float = 0, callback: Callable = empty_callback) -> void:
	current_animation = animation
	current_callback = callback
	$Duration.wait_time = duration
	$Wait.wait_time = wait
	$Wait.start()

func empty_callback() -> void:
	pass

func get_anim(animation: String) -> AnimatedSprite2D:
	return get_node("AS_" + animation)
