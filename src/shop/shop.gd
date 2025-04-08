extends VBoxContainer

var balance: int:
	set(val):
		balance = val
		if $Balance/Label:
			$Balance/Label.text = str(val)
		for child in $VBoxContainer.get_children():
			if child is Property:
				child.update_button(val)

func _ready() -> void:
	balance = 0 # Here to trigger the setter and redraw the buttons with correct visuals
	for child in $VBoxContainer.get_children():
		if child is Property:
			child.plus_button_clicked.connect(self.buy_upgrade)

func buy_upgrade(property: Property):
	var price = property.price()
	if balance >= price:
		property.upgrade()
		balance -= price

func player_properties() -> PlayerProperties:
	var properties = PlayerProperties.new()
	
	properties.ship_hitpoints = $VBoxContainer/Hitpoints.value()
	properties.ship_power = $VBoxContainer/ShipPower.value()
	properties.ship_steering_angle = $VBoxContainer/ShipSteeringAngle.value()
	properties.ship_ramming_damage = $VBoxContainer/ShipRammingDamage.value()
	properties.projectile_damage = $VBoxContainer/CannonDamage.value()
	
	return properties
