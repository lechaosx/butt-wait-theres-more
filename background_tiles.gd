class_name BackgroundTiles extends Node2D

@onready var tiles_scene = preload("res://sea_tiles.tscn")
@onready var player = %PlayerShip

@export var px_size: Vector2

@export var tile_width = 10
@export var tile_height = 6
@export var tile_px_size = 256

var regions: Array[TileMapLayer] = []

func _init() -> void:
	px_size = Vector2(tile_width * tile_px_size, tile_height * tile_px_size)
	pass

func _ready() -> void:
	for i in range(4):
		var scn = tiles_scene.instantiate()
		add_child(scn)
		regions.append(scn)
	pass
	
func _process(delta: float) -> void:
	var current_region = 0
	for i in range(4):
		var rect = Rect2(regions[i].position, px_size)
		if rect.has_point(player.position):
			current_region = i
			break
	
	var tmp = regions[0].position
	regions[0].position = regions[current_region].position
	regions[current_region].position = tmp
	
	var region = regions[0]
	var player_dir = sign(player.position - region.position)
	
	
	regions[1].position = region.position + player_dir * px_size
	regions[2].position = region.position + Vector2(player_dir.x, 0) * px_size
	regions[3].position = region.position + Vector2(0, player_dir.y) * px_size

	# print(player.position, regions[0].position, player_dir, regions[1].position, regions[2].position, regions[3].position)
