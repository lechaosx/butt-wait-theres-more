class_name UpgradeButton extends HBoxContainer

signal button_pressed

@export var no_money_font_color = Color(0.53, 0.141333, 0.106)
@export var no_money_font_color_hover = Color(0.96, 0.4232, 0.3744)

var upgrade: Upgrade
var balance: int = 0

func _process(_delta: float) -> void:
	$Name.text = upgrade.name
	
	$Value.text = str(upgrade.value())
	
	if $Button.is_hovered():
		$Increment.text = "+%d" % upgrade.value_increment
		$Button.text = "%d +%d" % [upgrade.price(), upgrade.price_increment]
	else:
		$Increment.text = ""
		$Button.text = str(upgrade.price())
		
	if balance < upgrade.price():
		$Button.add_theme_color_override("font_color", no_money_font_color)
		$Button.add_theme_color_override("font_hover_color", no_money_font_color_hover)
	else:
		$Button.remove_theme_color_override("font_color")
		$Button.remove_theme_color_override("font_hover_color")

func _on_button_pressed() -> void:
	button_pressed.emit()
