extends Button

@export var ability: Ability:
	set(value):
		%Name.text = value.name
		%Texture.texture = value.image
		%Level.text = "%d / %d" % [value.current_level, value.max_level]
