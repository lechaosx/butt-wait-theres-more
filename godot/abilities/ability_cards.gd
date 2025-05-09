extends Control

signal ability_selected(ability: Ability)

func select_ability(abilities: Array[Ability]) -> void:
	visible = true
	
	for node in %CardContainer.get_children():
		node.queue_free()
			
	for ability in abilities:
		var card := preload("ability_card.tscn").instantiate()
		card.ability = ability
		card.pressed.connect(_on_card_pressed.bind(ability))
		%CardContainer.add_child(card)
		
func _on_card_pressed(ability: Ability) -> void:
	visible = false
	ability_selected.emit(ability)
