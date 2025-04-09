extends VBoxContainer

var upgrades: Array:
	set(value):
		for button in %UpgradeButtons.get_children():
			button.queue_free()
		
		upgrades = value
		
		for upgrade in upgrades:
			var button = preload("res://src/properties/upgrade_button.tscn").instantiate()
			button.balance = balance
			button.upgrade = upgrade
			button.button_pressed.connect(_on_upgrade_button_pressed.bind(upgrade))
			%UpgradeButtons.add_child(button)

var balance: int = 0:
	set(value):
		balance = value
		%CurrentBalanceLabel.text = str(balance)
		for button in %UpgradeButtons.get_children():
			button.balance = balance
			
func _on_upgrade_button_pressed(upgrade: Upgrade):
	var price = upgrade.start_price + upgrade.price_increment * upgrade.level
	if balance >= price:
		balance -= price
		upgrade.level += 1
