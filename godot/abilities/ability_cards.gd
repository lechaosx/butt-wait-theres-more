extends Control

signal ability_selected(ability: Ability)

func select_ability(abilities: Array[Ability]) -> Signal:
	visible = true
	
	for node in %CardContainer.get_children():
		node.queue_free()
			
	for ability in abilities:
		var card := preload("ability_card.tscn").instantiate()
		card.ability = ability
		card.pressed.connect(func() -> void:
			visible = false
			ability_selected.emit(ability)
		)
		%CardContainer.add_child(card)
		
	return ability_selected
