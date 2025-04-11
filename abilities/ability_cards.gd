extends Control

signal ability_selected(ability: Ability)

@export var abilities: Array[Ability] = []:
	set(value):
		for node in %CardContainer.get_children():
			node.queue_free()
			
		for ability in value:
			var card := preload("ability_card.tscn").instantiate()
			card.ability = ability
			card.pressed.connect(_on_card_selected.bind(ability))
			%CardContainer.add_child(card)
			
func _on_card_selected(ability: Ability) -> void:
	visible = false
	ability_selected.emit(ability)
