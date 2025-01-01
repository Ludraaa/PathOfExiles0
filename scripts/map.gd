extends TileMapLayer

func _use_tile_data_runtime_update(coords):
	var tile = get_parent().get_node("Props").get_cell_tile_data(coords)
	if tile:
		if tile.get_collision_polygons_count(0) != 0:
			return true
		else:
			return false
	else:
		false

func _tile_data_runtime_update(coords, tile_data):
	tile_data.set_navigation_polygon(0, null)
