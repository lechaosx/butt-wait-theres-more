@tool extends VBoxContainer

var upgrades: Array:
	set(value):
		upgrades = value

		if not is_node_ready(): await ready
	
		for button in %UpgradeButtons.get_children():
			button.queue_free()
		
		for upgrade: Upgrade in upgrades:
			var button := preload("res://properties/upgrade_button.tscn").instantiate()
			button.disabled = balance < upgrade.price()
			button.upgrade = upgrade
			button.button_pressed.connect(func() -> void:
				balance -= upgrade.price()
				upgrade.level += 1
			)
			%UpgradeButtons.add_child(button)

var balance: int = 0:
	set(value):
		balance = value

		if not is_node_ready(): await ready

		%CurrentBalanceLabel.text = str(balance)
		for button in %UpgradeButtons.get_children():
			button.disabled = balance < button.upgrade.price()
			
