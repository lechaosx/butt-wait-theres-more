class_name Property extends HBoxContainer

@export var property: PropertyResource
@export var property_name: String
@export var default_value: int
@export var defailt_price: int

@export var no_money_font_color = Color.from_string("#93413aff", Color.DARK_RED)
@export var no_money_font_color_hover = Color.from_string("#93413aff", Color.FIREBRICK)

var mouse_inside:bool

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
	if not property:
		return
	property.upgrade()
	value_updated.emit(value())
	$Value.text = "   %d" % value()
	if mouse_inside:
		$Button.text =  "%d +%d" % [price(), property.price_increment]
	else:
		$Button.text = str(price())
	
func update_button(balance:int):
	if balance < price():
		$Button.add_theme_color_override("font_color", no_money_font_color)
		$Button.add_theme_color_override("font_hover_color", no_money_font_color_hover)
	else:
		$Button.remove_theme_color_override("font_color")
		$Button.remove_theme_color_override("font_hover_color")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if property_name:
		$Name.text = property_name
	$Value.text = "   %d" % value()
	$Button.text = "%d" % price()

func _on_button_pressed() -> void:
	plus_button_clicked.emit(self)

func _on_button_mouse_entered() -> void:
	if property:
		$Increment.text = "+%d" % property.increment
		$Button.text =  "%d +%d" % [price(), property.price_increment]
	mouse_inside = true


func _on_button_mouse_exited() -> void:
	$Increment.text = ""
	$Button.text = "%d" % price()
	mouse_inside = false
