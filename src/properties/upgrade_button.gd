class_name UpgradeButton extends HBoxContainer

signal button_pressed

var upgrade: Upgrade
var balance: int = 0

func _process(delta: float) -> void:
	$Name.text = upgrade.name
	
	$Value.text = str(upgrade.value())
	
	if $Button.is_hovered():
		$Increment.text = "+%d" % upgrade.value_increment
		$Button.text = "%d +%d" % [upgrade.price(), upgrade.price_increment]
	else:
		$Increment.text = ""
		$Button.text = str(upgrade.price())
		
	if balance < upgrade.price():
		$Button.add_theme_color_override("font_color", Color("#93413aff"))
		$Button.add_theme_color_override("font_hover_color", Color("#93413aff"))
	else:
		$Button.remove_theme_color_override("font_color")
		$Button.remove_theme_color_override("font_hover_color")

func _on_button_pressed() -> void:
	button_pressed.emit()
