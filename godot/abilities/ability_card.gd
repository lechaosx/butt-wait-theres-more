extends Button

@export var ability: Ability:
	set(value):
		%Name.text = value.info.name
		%Texture.texture = value.info.image
		%Level.text = "%d / %d" % [value.level(), value.info.max_level]
