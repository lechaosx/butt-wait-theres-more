class_name Property
extends HBoxContainer

@export var property: PropertyResource
@export var property_name: String
@export var default_value: int
@export var defailt_price: int

signal value_updated(value:int)
signal plus_button_clicked(property:Property)

func upgrades() -> int:
	if property:
		return property.upgrades
	return 0

func max_upgrades() -> int:
	if property:
		return property.max_number_of_upgrades
	return 0

func value() -> int:
	if property:
		return property.value()
	return default_value

func price() -> int:
	if property:
		return property.price()
	return defailt_price

func upgrade()->void:
	if property:
		property.upgrade()
	value_updated.emit(value())
	$Value.text = "   %d" % value()
	$Button.text = str(price())
	
func update_button(balance:int):
	if balance >= price():
		$Button.add_theme_color_override("font_color", "#FFFFFF")
	else:
		$Button.add_theme_color_override("font_color", "#C41E3A")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug($Name)
	if property_name:
		$Name.text = property_name
	$Value.text = "   %d" % value()
	$Button.text = "%d" % price()

func _on_button_pressed() -> void:
	plus_button_clicked.emit(self)

func _on_button_mouse_entered() -> void:
	if property:
		$Increment.text = "+%d" % property.increment


func _on_button_mouse_exited() -> void:
	$Increment.text = ""
