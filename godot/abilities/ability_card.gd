extends Button

@export var ability: Ability:
	set(value):
		ability = value
		
		if not is_node_ready(): await ready
		
		%Name.text = ability.info.name
		%Texture.texture = ability.info.image
		%Level.text = "%d / %d" % [ability.level(), ability.info.max_level]
