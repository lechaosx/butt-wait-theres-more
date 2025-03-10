extends VBoxContainer

@onready var balance: int:
	set(val):
		balance = val
		if $Balance/Label:
			$Balance/Label.text = str(val)
		for child in $VBoxContainer.get_children():
			if child is Property:
				child.update_button(val)

func _ready() -> void:
	balance = 0
	for child in $VBoxContainer.get_children():
		if child is Property:
			child.plus_button_clicked.connect(self.buy_upgrade)

func buy_upgrade(property:Property):
	if balance >= property.price():
		property.upgrade()
		balance -= property.price()

func update_balance(delta:int):
	balance += delta

func update_properties(sea:Sea) -> void:
	var properties : PlayerProperties = PlayerProperties.new()
	
	properties.ship_hitpoints = $VBoxContainer/Hitpoints.value()
	properties.ship_power = $VBoxContainer/ShipPower.value()
	properties.ship_steering_angle = $VBoxContainer/ShipSteeringAngle.value()
	properties.ship_ramming_damage = $VBoxContainer/ShipRammingDamage.value()
	properties.projectile_damage = $VBoxContainer/CannonDamage.value()
	properties.man_overboard_healing = $VBoxContainer/SailorHeal.value()
	
	sea.update_properties(properties)
