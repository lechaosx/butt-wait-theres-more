class_name DamagePopup extends Marker2D

func set_text(val: int) -> void:
	$Label.text = str(val)

func _process(_delta: float) -> void:
	rotation = - get_parent().rotation
