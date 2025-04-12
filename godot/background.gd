class_name Background extends Node2D

var regions: Array[BackgroundRegion] = []
var px_size: Vector2

func _ready() -> void:
	for i in range(4):
		var scn := preload("res://background_region.tscn").instantiate()
		add_child(scn)
		regions.append(scn)
	px_size = regions[0].px_size
	
func _process(_delta: float) -> void:
	var current_region: int = 0
	for i in range(4):
		var rect := Rect2(regions[i].position - 0.5 * px_size, px_size)
		if rect.has_point(%PlayerShip.position):
			current_region = i
			break
	
	swap_regions(0, current_region)
	
	var player_dir: Vector2 = sign(%PlayerShip.position - regions[0].position)
	
	var diag_region_pos := regions[0].position + player_dir * px_size
	var x_region_pos := regions[0].position + Vector2(player_dir.x, 0) * px_size
	var y_region_pos := regions[0].position + Vector2(0, player_dir.y) * px_size
	
	var diag_region := find_region_by_position(diag_region_pos, 1)
	swap_regions(1, diag_region)
	var x_region := find_region_by_position(x_region_pos, 2)
	swap_regions(2, x_region)
	var y_region := find_region_by_position(y_region_pos, 2)
	swap_regions(3, y_region)
	
	regions[1].position = diag_region_pos
	regions[2].position = x_region_pos
	regions[3].position = y_region_pos
	
	
func swap_regions(i: int, j: int) -> void:
	if i != j:
		var tmp := regions[i]
		regions[i] = regions[j]
		regions[j] = tmp
		
func find_region_by_position(p: Vector2, default: int) -> int:
	for i in range(4):
		if regions[i].position == p:
			return i
	return default

	# print(%PlayerShip.position, regions[0].position, player_dir, regions[1].position, regions[2].position, regions[3].position)
