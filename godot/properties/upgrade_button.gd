@tool class_name UpgradeButton extends HBoxContainer

signal button_pressed

var upgrade: Upgrade

var disabled: bool = true:
	set(value):
		$Button.disabled = value
	get: return $Button.disabled

func _process(_delta: float) -> void:
	if not upgrade:
		return
		
	$Name.text = upgrade.name
	
	$Value.text = str(upgrade.value())
	
	if $Button.is_hovered():
		$Increment.text = "+%d" % upgrade.value_increment
		$Button.text = "%d +%d" % [upgrade.price(), upgrade.price_increment]
	else:
		$Increment.text = ""
		$Button.text = str(upgrade.price())
		
func _on_button_pressed() -> void:
	button_pressed.emit()
